#ifndef HW_AES_H
#define HW_AES_H

// Refer to : https://support.xilinx.com/s/question/0D52E00006hpYgWSAU/vitis-ide-20211-custom-axi-ip-core-compile-error?language=en_US
// If AXI core wrapper has issues compiling
// May have been fixed in newer version (post 2022.1) of vivado/vitis


#include "xil_io.h"

//#define HW_AES_DEBUG


/** Memory address macros for encryption hardware **/
#define AES_b 0x43C00000

// Offsets
// Key input
#define REG_0_o 0x0 // Key input Least Significant 32-Bits
#define REG_1_o 0x4
#define REG_2_o 0x8
#define REG_3_o 0xC
#define REG_4_o 0x10
#define REG_5_o 0x14
#define REG_6_o 0x18
#define REG_7_o 0x1C // First Key input Most Significant 32-bits

// Plaintext
#define REG_8_o 0x20 // Plaintext Input Least Significant 32 bits
#define REG_9_o 0x24
#define REG_10_o 0x28
#define REG_11_o 0x2C  // Plaintext Input Most significant 32 bits

// Input control
#define REG_12_o 0x30  // Encryption Start
#define REG_13_o 0x34  // Key Expansion Start

// Cipher Text Output
#define REG_14_o 0x38  // Ciphertext output Least Significant 32-bits
#define REG_15_o 0x3C  
#define REG_16_o 0x40  
#define REG_17_o 0x44  // Ciphertext output Most Significant 32-bits

// Output Control
#define REG_18_o 0x48 // Encryption finished output
#define REG_19_o 0x4C // Key expansion finished output

// Key select
#define REG_20_o 0x50 // Key select first bit

// Decryption base addresses
//Cipher text input
#define REG_21_o 0x54 // Ciphertext input least Significant 32-bits
#define REG_22_o 0x58
#define REG_23_o 0x5C
#define REG_24_o 0x60 // Ciphertext input Most Significant 32-bits

// Input control
#define REG_25_o 0x64 // Decryption Start bit

// Plain text output
#define REG_26_o 0x68 // Plaintext output least Significant 32-bits
#define REG_27_o 0x6C
#define REG_28_o 0x70
#define REG_29_o 0x74 // Plaintext output least Significant 32-bits

// Output control
#define REG_30_o 0x78 // Decryption Finish bit

/** Function Prototypes **/
u32 u8_to_u32(uint8_t* input);
void hw_aes_write_key(u32 key_word7, u32 key_word6, u32 key_word5, u32 key_word4,
        					  u32 key_word3, u32 key_word2, u32 key_word1, u32 key_word0);
int hw_aes_start_keyexp();
void hw_aes_enc_new_key(uint8_t* key);
void hw_aes_dec_new_key(uint8_t* key);

int hw_aes_start_enc();
void hw_aes_write_enc_data(u32 data_word11, u32 data_word10, u32 data_word9, u32 data_word8);
void hw_aes_encrypt(uint8_t* buf);

int hw_aes_start_dec();
void hw_aes_write_dec_data(u32 data_word11, u32 data_word10, u32 data_word9, u32 data_word8);
void hw_aes_decrypt(uint8_t* buf);


#endif
