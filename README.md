# DeteccionBordes_SEI
Real-time edge detection via webcam and XILINX PYNQ-Z2 FPGA

# INTRODUCCIÓN 

El trabajo se centra en la transformación de un algoritmo Sobel desde una descripción de alto nivel hasta un acelerador hardware, poniendo el foco principal en el uso de Vitis HLS como herramienta clave para la síntesis y optimización del diseño. Vivado y Vitis se emplean posteriormente como etapas de integración y control dentro del flujo sobre una FPGA Zynq-7000. 

La detección de bordes identifica cambios bruscos de intensidad en una imagen, es decir, los contornos que delimitan objetos o estructuras. Estos bordes concentran la información visual más relevante y funcionan como un filtro inicial que simplifica la imagen, facilitando procesamientos más rápidos y eficientes en sistemas con limitaciones de tiempo y recursos. 

## Justificaciones reales de uso: 

* Control de calidad en circuitos impresos (detección de pistas rotas, soldaduras defectuosas). 

* Inspección industrial automatizada (detectar grietas, defectos, alineación incorrecta). 

* Sistemas de visión para robótica (identificación de contornos para navegación o manipulación). 

* Preprocesado en visión artificial (segmentación, reconocimiento de objetos). 

* Aplicaciones médicas (resaltar estructuras anatómicas en imágenes). 

* Seguridad y vigilancia (detección de siluetas o intrusiones). 

El operador Sobel es un método muy usado para detectar bordes por su simplicidad, robustez al ruido y bajo coste computacional. Aplica dos pequeños filtros para detectar cambios horizontales y verticales, con cálculos locales y repetitivos que permiten procesar muchos píxeles en paralelo, haciéndolo ideal para implementaciones hardware como las FPGA. 

# IMPLEMENTACIÓN EN VITIS HLS 2022 

## Objetivo: 

Convertir el algoritmo Sobel en hardware sintetizable. Esto permite que la operación de detección de bordes se ejecute directamente en FPGA, aprovechando la paralelización y el streaming de datos, en lugar de ejecutarse en software sobre la CPU. 

## Uso de librerías: 

### OpenCV 

Se utiliza en el test bench para validar el algoritmo en software. Permite leer imágenes, mostrar resultados y comprobar que la implementación hardware genera el mismo resultado que la versión software. 

### Vitis Vision / xfOpenCV 

Conjunto de funciones optimizadas para FPGA. Incluye operaciones de procesamiento de imágenes y permite generar IPs con interfaces AXI4-Stream, listas para integrarse con VDMA o otros bloques. 

## Estructura del IP: 

 

* `_src` y `_dst`: stream AXI4-Stream que transportan datos de imágenes. 

* `rows` y `cols`: dimensiones de la imagen 

* `#pragma HLS INTERFACE`: indica a HLS cómo generar los puertos hardware: axis (puertro de streaming AXI4) y s_axilite (puerto AXI-Lite para control/configuración) 

 

Constantes de tamaño y ancho del bus. La IP queda parametrizada y puede procesar imágenes de tamaño fijo, con 32 bits por pixel en el stream 

La función top-level realiza todo el flujo de procesameinto de la imagen 

 

Activa la ejecución en paralelo de los distions bloques, permitiendo que mietras un píxel entra, otro ya esté siendo procesado en la siguiente etapa. 

 

* `AXIvideo2xfMat`: Convierte el stream de entrada _src en una matriz interna (xf::cv::Mat) usable por xfOpenCV. 

* `Bgr2gray`: Convierte la imagen de color a escala de grises, reduciendo la complejidad para el cálculo de bordes. 

* `Sobel`: Aplica el filtro de Sobel en X y Y, generando dos matrices intermedias (img_buf_1a, img_buf_1b) con los gradientes. 

* `AddWeighted`: Combina los gradientes X e Y para obtener la magnitud final del borde. 

* `Gray2bgr`: Convierte la imagen de vuelta a color . 

* `XfMat2AXIvideo`: Convierte la matriz de salida a un stream AXI4-Stream _dst, listo para enviarse a VDMA o directamente a un bloque de visualización 

Cada etapa tiene su propio buffer para permitir dataflow y paralelismo. Se usan tipos como `XF_8UC1` y `XF_8UC3` para representar imágenes de 1 canal (gris) o 3 canales (color). 

## Test bench 

Se creó un test bench para validar el IP antes de integrarlo en Vivado. 

Usa OpenCV para cargar una imagen 

 

Convierte la imagen a AXI stream: 

 

Llama al kernel HLS: 

 

Convierte la salida de vuelta a Mat para guardar la imagen: 

Mostrar la imagen de entrada y la imagen resultante. 

 

# INTREGRACIÓN EN VIVADO 

## Exportación del IP desde HLS 

El bloque generado: hls_sobel_axi_stream. 

## Interconexión 

El diseño hardware se estructura en torno al procesador Zynq-7000 (processing_system7_0), que actúa como núcleo de control y coordinación del procesamiento. El procesador se conecta directamente a la memoria DDR y a los pines físicos del dispositivo mediante el bloque FIXED_IO. 

Para garantizar una inicialización correcta del sistema, se incluye el bloque proc_sys_reset, que sincroniza las señales de reset provenientes del procesador y asegura un arranque coherente de todos los módulos del diseño. 

La comunicación entre el procesador y los periféricos se realiza a través de la interconexión AXI (ps7_0_axi_periph / axi_interconnect). En este sistema se emplean dos tipos de interfaces: 

AXI4-Lite, utilizada para el control del IP Sobel. 
A través de esta interfaz, el procesador configura el bloque hls_sobel_axi_stream_0, estableciendo parámetros como el número de filas y columnas de la imagen y activando su ejecución. 

AXI4-Stream, utilizada para el flujo de datos de imagen. 
Las imágenes se transmiten como flujos de píxeles desde y hacia el IP Sobel, sin necesidad de accesos directos del procesador a cada píxel. 

El bloque AXI DMA (o AXI VDMA) es el encargado de gestionar la transferencia de datos entre la memoria DDR y el IP Sobel, permitiendo que el procesamiento de imágenes se realice sin intervención directa del procesador. El procesador únicamente prepara la imagen en memoria y configura las transferencias, mientras que el DMA envía los datos al IP mediante AXI4-Stream, recibe la imagen procesada y la vuelve a almacenar en DDR. Este esquema desacopla el cálculo del procesador, aprovecha el procesamiento en streaming y el paralelismo de la FPGA, y reduce significativamente la carga de la CPU. 

## Síntesis y bitstream 

Una vez finalizado el diseño en Vivado, se lleva a cabo la síntesis para obtener la implementación física en la FPGA y, tras verificar el diseño, se genera el bitstream. Este archivo se exporta junto con la descripción del sistema para su uso en Vitis, donde se desarrolla la aplicación software que controla el hardware. 

# APLICACIÓN EN VITIS 

En la última etapa del proyecto se abordó la implementación del software en Vitis, cuyo objetivo era ejecutar una aplicación en el procesador ARM del Zynq para controlar el sistema hardware desarrollado en Vivado y gestionar el uso del IP Sobel. 

Durante la ejecución del programa apareció un error de conexión JTAG que impide a Vitis acceder al procesador, aunque el dispositivo FPGA es detectado correctamente. Este problema ocurre antes de que el software llegue a ejecutarse y está relacionado con la integración hardware-software, no con el algoritmo ni con el IP HLS. 

Una vez resuelto este punto, el objetivo sería presentar los resultados del sistema completo, mostrando imágenes de entrada y salida para validar visualmente la detección de bordes. También sería interesante comparar tiempos de ejecución en software frente a hardware, evidenciando la aceleración obtenida mediante el uso de FPGA. 

Además, se analizaría el uso de recursos hardware, como LUTs, FFs, BRAMs y DSPs, para evaluar el coste del acelerador. Por último, se estudiarían posibles cuellos de botella, especialmente relacionados con el DMA, el ancho de banda de memoria y la latencia en el acceso a DDR. 

# CONCLUSIONES Y TRABAJO FUTURO 

En este trabajo se ha abordado la implementación en hardware de un algoritmo de detección de bordes basado en Sobel, poniendo el foco principal en el uso de Vitis HLS como herramienta para transformar un algoritmo de alto nivel en un acelerador hardware sintetizable. Se ha diseñado y validado funcionalmente el IP mediante test bench, integrándolo posteriormente en una arquitectura Zynq junto con los bloques estándar de comunicación y control. Aunque la fase de ejecución completa desde software no ha podido finalizarse, el trabajo realizado permite comprender en profundidad el flujo de diseño hardware–software y deja establecida una base sólida para la extensión del sistema, incluyendo la evaluación de rendimiento, uso de recursos y aceleración frente a soluciones puramente software. 
