#set document(
  title: [Lecture 10 - DMA],
  author: "Albert Sáez Núñez, s250445",
)

#set heading(numbering: "1.")
#set page(
  header: [
    34373 Microntrollers - Lecture 10: DMA | s250445, Albert Sáez Núñez]
)

#title()
#outline()
#pagebreak()

= Task: Minimal UART with DMA

#figure(
  image("assets/ex1-setup.png", width: 75%),
  caption: [Clock setup for the exercise 1.]
)

#figure(
  grid(
    columns: 2,
    image("assets/ex1-uart2.png"),
    image("assets/ex1-usart2_bit.png"),
  ),
  caption: [
    (Left) DMA setup for UART 2.
    (Right) Basic parameters for UART setup.
  ]
)

== Inquiries

The code `huart.Instance->CR3` is a direct manipulation of the DMA UART
manipulation. The operation `|= USART_CR3_DMAT` enables the operation of
hardware data transmission. The other option `&= ~USART_CR3_DMAT`, clears
the register or at least the DMA enable bit.

It is possible to replicate, or rather opacate the register manipuation of
the previous instructions.

Please, refer to the attached videos for the demonstration.

= Task: ADC With DMA

#figure(
  image("assets/ex2-setup.png", width: 75%),
  caption: [Clock setup for the exercise 2.]
)

#figure(
  grid(
    columns: 2,
    image("assets/ex2-adc.png"),
    image("assets/ex2-nvic-set.png")
  ),
  caption: [
    (Left) ADC DMA setup .
    (Right) NVIC setup.
  ]
)
#pagebreak()

== Implementation

```c
  
  // Start the ADC in DMA mode.
  // Because "Continuous Conversion" is enabled, the DMA will continuously 
  // overwrite adc_ram_buffer[0] in the background automatically.
  HAL_ADC_Start_DMA(&hadc1, (uint32_t*)adc_ram_buffer, 1);

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    HAL_Delay(1000);

    float voltage = (adc_ram_buffer[0] / 4095.0f) * 3.3f;
    float temp_celsius = (voltage - 0.5f) * 100.0f;

    sprintf(uart_tx_buffer, "Temp: %.2f C\r\n", temp_celsius);

    HAL_UART_Transmit_DMA(&huart2, (uint8_t*)uart_tx_buffer, strlen(uart_tx_buffer));

    HAL_GPIO_TogglePin(LED_GPIO_Port, LED_Pin);

    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
```

The implementation uses the `HAL_UART_Transmit_DMA` function that replaces
the previous register manipulation.

Please, refer to the attached videos for the demonstration.
