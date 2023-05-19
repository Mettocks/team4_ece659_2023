/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "hw_aes.h"
// #include "hw_aes_test.h"

#define PLAINTEXT_LEN 16 // in bytes
#define KEY_LEN 32 // in bytes


// prototypes

LONG hw_aes_enc_func_test();
LONG hw_aes_change_test();
LONG hw_aes_dec_func_test();


void Str_To_Hex(char *str, u32 len){
	//xil_printf("Str into hex: ");
	for (int i = 0; i < len; i++) {
		if (i % 16 == 0) { xil_printf("\r\n"); }
		xil_printf("%02x", (uint8_t) str[i]);

	}
	xil_printf("\r\n");
}


int main()
{
    init_platform();

    xil_printf("----HW AES TEST-----\r\n");

    LONG ret;

    ret = hw_aes_enc_func_test();
    print("Successfully ran encrypt functionality test\n\r");

    ret = hw_aes_dec_func_test();
    print("Successfully ran decrypt functionality test\n\r");

//    ret = hw_aes_change_test();
//    print("Successfully ran encrypt changing input test\n\r");



    cleanup_platform();
    return 0;
}



LONG hw_aes_enc_func_test(){

	char text_buffer[PLAINTEXT_LEN] = "\x00\x11\x22\x33\x44\x55\x66\x77\x88\x99\xaa\xbb\xcc\xdd\xee\xff";

	const uint8_t key[KEY_LEN] = "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f";


    // uint8_t *encrypted_buf;
    // uint32_t encrypted_buf_len;
    // uint8_t *output_buf;
    // uint32_t output_len;


    xil_printf("--------- HW AES Encrypt Test ---------\r\n");

    xil_printf("AES Key hex plaintext:");
    Str_To_Hex((uint8_t *) key, 32);

    hw_aes_enc_new_key((uint8_t *) key);
    //hw_aes_start_keyexp();

    xil_printf("Key expansion finished\r\n");

    xil_printf("Input hex plaintext:");
    Str_To_Hex((uint8_t *) text_buffer, PLAINTEXT_LEN);
    xil_printf("\r\n");

    hw_aes_encrypt((uint8_t *) text_buffer);

    xil_printf("test func encrypted out:");
    Str_To_Hex((char *) text_buffer, PLAINTEXT_LEN);
    // should expect 8ea2b7ca516745bfeafc49904b496089

	return 0UL;
}

LONG hw_aes_change_test(){

	const uint8_t key[KEY_LEN] = "\x60\x3d\xeb\x10\x15\xca\x71\xbe\x2b\x73\xae\xf0\x85\x7d\x77\x81\x1f\x35\x2c\x07\x3b\x61\x08\xd7\x2d\x98\x10\xa3\x09\x14\xdf\xf4";

    // uint8_t *encrypted_buf;
    // uint32_t encrypted_buf_len;
    // uint8_t *output_buf;
    // uint32_t output_len;


    xil_printf("--------- HW AES Changing Input Test ---------\r\n");

    xil_printf("AES Key hex plaintext:");
    Str_To_Hex((uint8_t *) key, 32);

    hw_aes_enc_new_key((uint8_t *) key);
    //hw_aes_start_keyexp();


    xil_printf("Key expansion finished\r\n");
    /*-----------*/

	char text_buffer0[PLAINTEXT_LEN] = "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff";
    xil_printf("Input hex plaintext:");
    Str_To_Hex((uint8_t *) text_buffer0, PLAINTEXT_LEN);
    xil_printf("\r\n");

    hw_aes_encrypt((uint8_t *) text_buffer0);
    xil_printf("test func encrypted out:");
    Str_To_Hex((char *) text_buffer0, PLAINTEXT_LEN);
    //expected: 0bdf7df1591716335e9a8b15c860c502

    xil_printf("------------------------\r\n");
    /*-----------*/

    char text_buffer1[PLAINTEXT_LEN] = "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xff\x00";

    xil_printf("Input hex plaintext:");
    Str_To_Hex((uint8_t *) text_buffer1, PLAINTEXT_LEN);
    xil_printf("\r\n");

    hw_aes_encrypt((uint8_t *) text_buffer1);

    xil_printf("test func encrypted out:");
    Str_To_Hex((char *) text_buffer1, PLAINTEXT_LEN);
    // should expect 5a6e699d536119065433863c8f657b94

    xil_printf("------------------------\r\n");
    /*-----------*/

    char text_buffer2[PLAINTEXT_LEN] = "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xff\x01";

    xil_printf("Input hex plaintext:");
    Str_To_Hex((uint8_t *) text_buffer2, PLAINTEXT_LEN);
    xil_printf("\r\n");

    hw_aes_encrypt((uint8_t *) text_buffer2);

    xil_printf("test func encrypted out:");
    Str_To_Hex((char *) text_buffer2, PLAINTEXT_LEN);
    // should expect 1bc12c9c01610d5d0d8bd6a3378eca62

    xil_printf("------------------------\r\n");


    char text_buffer3[PLAINTEXT_LEN] = "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7\xf8\xf9\xfa\xfb\xfc\xfd\xff\x02";

    xil_printf("Input hex plaintext:");
    Str_To_Hex((uint8_t *) text_buffer3, PLAINTEXT_LEN);
    xil_printf("\r\n");

    hw_aes_encrypt((uint8_t *) text_buffer3);

    xil_printf("test func encrypted out:");
    Str_To_Hex((char *) text_buffer3, PLAINTEXT_LEN);
    // should expect 2956e1c8693536b1bee99c73a31576b6

    xil_printf("------------------------\r\n");

	return 0UL;
}

LONG hw_aes_dec_func_test(){

	char text_buffer[PLAINTEXT_LEN] = "\x8e\xa2\xb7\xca\x51\x67\x45\xbf\xea\xfc\x49\x90\x4b\x49\x60\x89";

	const uint8_t key[KEY_LEN] = "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f";


    // uint8_t *encrypted_buf;
    // uint32_t encrypted_buf_len;
    // uint8_t *output_buf;
    // uint32_t output_len;


    xil_printf("--------- HW AES Decrypt Test ---------\r\n");

    xil_printf("AES Key hex plaintext:");
    Str_To_Hex((uint8_t *) key, 32);

    hw_aes_dec_new_key((uint8_t *) key);
    //hw_aes_start_keyexp();

    xil_printf("Key expansion finished\r\n");

    xil_printf("Input hex ciphertext:");
    Str_To_Hex((uint8_t *) text_buffer, PLAINTEXT_LEN);
    xil_printf("\r\n");

    hw_aes_decrypt((uint8_t *) text_buffer);

    xil_printf("test func decrypt out:");
    Str_To_Hex((char *) text_buffer, PLAINTEXT_LEN);
    // should expect 00112233445566778899aabbccddeeff

	return 0UL;
}

