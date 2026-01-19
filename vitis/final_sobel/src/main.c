#include "xparameters.h"
#include "xhls_sobel_axi_stream.h"
#include "xaxidma.h"
#include "xil_cache.h"
#include <stdlib.h>

#define DMA_DEV_ID      XPAR_AXIDMA_0_DEVICE_ID
#define SOBEL_DEV_ID    XPAR_HLS_SOBEL_AXI_STREAM_0_DEVICE_ID

#define IMG_WIDTH       128
#define IMG_HEIGHT      128
#define IMG_PIXELS      (IMG_WIDTH * IMG_HEIGHT)
#define IMG_SIZE        (IMG_PIXELS * 4)   // 32 bits por pixel

// Buffers de imagen en DDR
u32 input_image[IMG_PIXELS];
u32 output_image[IMG_PIXELS];

// Instancias
XAxiDma AxiDma;
XHls_sobel_axi_stream Sobel;

int main()
{
    int status;
    // 1️ Inicializar IP Sobel
    status = XHls_sobel_axi_stream_Initialize(&Sobel, SOBEL_DEV_ID);
    if (status != XST_SUCCESS) while(1);

    XHls_sobel_axi_stream_Set_rows(&Sobel, IMG_HEIGHT);
    XHls_sobel_axi_stream_Set_cols(&Sobel, IMG_WIDTH);
    XHls_sobel_axi_stream_Start(&Sobel);

    // 2️ Inicializar AXI DMA
    XAxiDma_Config *cfg = XAxiDma_LookupConfig(DMA_DEV_ID);
    if (!cfg) while(1);

    status = XAxiDma_CfgInitialize(&AxiDma, cfg);
    if (status != XST_SUCCESS) while(1);
    if (XAxiDma_HasSg(&AxiDma)) while(1);  // debe ser simple

    // 3️ Generar imagen de prueba
    for (int i = 0; i < IMG_PIXELS/2; i++) {
        input_image[i] = 0x00FF0000;   // rojo
    }
    for (int i = IMG_PIXELS/2; i < IMG_PIXELS; i++) {
        input_image[i] = 0x00000000;   // negro
    }

    // Flush de caché
    Xil_DCacheFlushRange((UINTPTR)input_image, IMG_SIZE);
    Xil_DCacheFlushRange((UINTPTR)output_image, IMG_SIZE);

    // 4️ Configurar DMA: salida del Sobel (S2MM)
    status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)output_image, IMG_SIZE, XAXIDMA_DEVICE_TO_DMA);
    if (status != XST_SUCCESS) while(1);

    // 5️ Configurar DMA: entrada al Sobel (MM2S)
    status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)input_image, IMG_SIZE, XAXIDMA_DMA_TO_DEVICE);
    if (status != XST_SUCCESS) while(1);

    // 6️ Esperar a que termine
    while (XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE));
    while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA));

    // Invalidate caché de salida
    Xil_DCacheInvalidateRange((UINTPTR)output_image, IMG_SIZE);

    // 7️ Bucle infinito
    while (1);

    return 0;
}
