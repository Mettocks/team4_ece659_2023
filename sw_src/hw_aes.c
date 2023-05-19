
#include "hw_aes.h"


// Helper
u32 u8_to_u32(uint8_t* input){
	u32 msb, lmsb, hlsb, lsb;
	msb = (input[0] << 24) & 0xFF000000;
	lmsb = (input[1] << 16)& 0x00FF0000;
	hlsb = (input[2] << 8 )& 0x0000FF00;
	lsb = (input[3])       & 0x000000FF;


	return msb | lmsb | hlsb | lsb;
}

/**Key expansion**/


void hw_aes_write_key(u32 key_word7, u32 key_word6, u32 key_word5, u32 key_word4,
        					 u32 key_word3, u32 key_word2, u32 key_word1, u32 key_word0)
{

    Xil_Out32(AES_b + REG_0_o, key_word0);
    Xil_Out32(AES_b + REG_1_o, key_word1);
    Xil_Out32(AES_b + REG_2_o, key_word2);
    Xil_Out32(AES_b + REG_3_o, key_word3);
    Xil_Out32(AES_b + REG_4_o, key_word4);
    Xil_Out32(AES_b + REG_5_o, key_word5);
    Xil_Out32(AES_b + REG_6_o, key_word6);
    Xil_Out32(AES_b + REG_7_o, key_word7);

#ifdef FNI_HW_AES_DEBUG
    xil_printf("\r\nfni_aes_write_key->checking registers against inputs:\r\n");
    u32 slv_reg0_rdata, slv_reg1_rdata, slv_reg2_rdata, slv_reg3_rdata;
    u32 slv_reg4_rdata, slv_reg5_rdata, slv_reg6_rdata, slv_reg7_rdata;

    slv_reg7_rdata = Xil_In32(AES_b + REG_7_o);
    xil_printf("Key word 7 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word7, slv_reg7_rdata);

    slv_reg6_rdata = Xil_In32(AES_b + REG_6_o);
    xil_printf("Key word 6 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word6, slv_reg6_rdata);

    slv_reg5_rdata = Xil_In32(AES_b + REG_5_o);
    xil_printf("Key word 5 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word5, slv_reg5_rdata);

    slv_reg4_rdata = Xil_In32(AES_b + REG_4_o);
    xil_printf("Key word 4 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word4, slv_reg4_rdata);

    slv_reg3_rdata = Xil_In32(AES_b + REG_3_o);
    xil_printf("Key word 3 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word3, slv_reg3_rdata);

    slv_reg2_rdata = Xil_In32(AES_b + REG_2_o);
    xil_printf("Key word 2 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word2, slv_reg2_rdata);

    slv_reg1_rdata = Xil_In32(AES_b + REG_1_o);
    xil_printf("Key word 1 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word1, slv_reg1_rdata);

    // Lowest word of key
    slv_reg0_rdata = Xil_In32(AES_b + REG_0_o);
    xil_printf("Key word 0 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word0, slv_reg0_rdata);
    xil_printf("\r\n");
#endif

	return;
}

int hw_aes_start_keyexp(){
    u32 done_bit;
    Xil_Out32(AES_b + REG_13_o, 0x1);

#ifdef FNI_HW_AES_DEBUG
    u32	read_go_bit = Xil_In32(AES_b + REG_13_o);
    xil_printf("keystart_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
#endif

#ifdef FNI_HW_AES_DEBUG
    u32	read_done_bit = Xil_In32(AES_b + REG_19_o);
    xil_printf("keyout_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x0, read_done_bit);
#endif

    while(1) {
        done_bit = Xil_In32(AES_b + REG_19_o) & 0x1; // poll bit
        if (done_bit == 1) {
            #ifdef FNI_HW_AES_DEBUG
            read_go_bit = Xil_In32(AES_b + REG_13_o);
            xil_printf("keystart_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x0, read_go_bit);
            xil_printf("Key Expansion Finished \r\n");
            #endif
            Xil_Out32(AES_b + REG_13_o, 0x0); // lower bit when complete
            break;
        } else {
            Xil_Out32(AES_b + REG_13_o, 0x0); // lower bit when complete
        }
    }
    return 1;
}

void hw_aes_enc_new_key(uint8_t* key){

	Xil_Out32(AES_b + REG_20_o, 0x0); // select encryption for new key

	hw_aes_write_key( u8_to_u32(&key[0]),
				   	  u8_to_u32(&key[4]),
					  u8_to_u32(&key[8]),
					  u8_to_u32(&key[12]),
					  u8_to_u32(&key[16]),
					  u8_to_u32(&key[20]),
					  u8_to_u32(&key[24]),
					  u8_to_u32(&key[28])
					 );

	hw_aes_start_keyexp();
	return;
}

void hw_aes_dec_new_key(uint8_t* key){

	Xil_Out32(AES_b + REG_20_o, 0x1); // select decryption for new key

	hw_aes_write_key( u8_to_u32(&key[0]),
				   	  u8_to_u32(&key[4]),
					  u8_to_u32(&key[8]),
					  u8_to_u32(&key[12]),
					  u8_to_u32(&key[16]),
					  u8_to_u32(&key[20]),
					  u8_to_u32(&key[24]),
					  u8_to_u32(&key[28])
					 );

	hw_aes_start_keyexp();
	return;
}

/** Encryption **/

int hw_aes_start_enc(){
    u32 done_bit;
#ifdef FNI_HW_AES_DEBUG
    u32	read_go_bit = Xil_In32(AES_b + REG_12_o);
    xil_printf("encstart_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
    read_go_bit = Xil_In32(AES_b + REG_18_o);
    xil_printf("encfin_bit   [e]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
#endif

    Xil_Out32(AES_b + REG_12_o, 0x1); // raise start bit

#ifdef FNI_HW_AES_DEBUG
    read_go_bit = Xil_In32(AES_b + REG_12_o);
    xil_printf("encstart_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
    read_go_bit = Xil_In32(AES_b + REG_18_o);
    xil_printf("encfin_bit   [e]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
#endif

    while(1) {
        done_bit = Xil_In32(AES_b + REG_18_o) & 0x1; // poll finished bit
        if (done_bit == 1) {
            #ifdef FNI_HW_AES_DEBUG
            read_go_bit = Xil_In32(AES_b + REG_12_o);
            xil_printf("keystart_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x0, read_go_bit);
            xil_printf("Encryption Finished \r\n");
            #endif
            Xil_Out32(AES_b + REG_12_o, 0x0); // lower bit
            break;
        } else {
            //Xil_Out32(AES_b + REG_12_o, 0x0); // lower bit
        	continue;
			#ifdef FNI_HW_AES_DEBUG
				read_go_bit = Xil_In32(AES_b + REG_12_o);
				xil_printf("encstart_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x0, read_go_bit);
				read_go_bit = Xil_In32(AES_b + REG_18_o);
				xil_printf("encfin_bit   [e]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
			#endif
        }
    }
    return 0;

}

void hw_aes_write_enc_data(u32 data_word11, u32 data_word10, u32 data_word9, u32 data_word8){
    Xil_Out32(AES_b + REG_8_o, data_word8);
    Xil_Out32(AES_b + REG_9_o, data_word9);
    Xil_Out32(AES_b + REG_10_o, data_word10);
    Xil_Out32(AES_b + REG_11_o, data_word11);
	return;
}

void hw_aes_encrypt(uint8_t* buf){
	u32 data_words[4];
	hw_aes_write_enc_data(u8_to_u32(&buf[0]),
					   u8_to_u32(&buf[4]),
					   u8_to_u32(&buf[8]),
					   u8_to_u32(&buf[12])
					   );
	hw_aes_start_enc(); //polls and blocks until completed
	data_words[0] = Xil_In32(AES_b + REG_17_o);
	data_words[1] = Xil_In32(AES_b + REG_16_o);
	data_words[2] = Xil_In32(AES_b + REG_15_o);
	data_words[3] = Xil_In32(AES_b + REG_14_o);
	for(int i = 0; i < 4; i++){
		buf[i*4] =   (data_words[i] & 0xFF000000) >> 24;
		buf[i*4+1] = (data_words[i] & 0x00FF0000) >> 16;
		buf[i*4+2] = (data_words[i] & 0x0000FF00) >> 8;
		buf[i*4+3] = (data_words[i] & 0x000000FF);
	}
	return;
}


/** Decryption **/

int hw_aes_start_dec(){
    u32 done_bit;
#ifdef FNI_HW_AES_DEBUG
    u32	read_go_bit = Xil_In32(AES_b + REG_25_o);
    xil_printf("decstart_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
    read_go_bit = Xil_In32(AES_b + REG_30_o);
    xil_printf("decfin_bit   [e]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
#endif

    Xil_Out32(AES_b + REG_25_o, 0x1); // raise start bit

#ifdef FNI_HW_AES_DEBUG
    read_go_bit = Xil_In32(AES_b + REG_25_o);
    xil_printf("decstart_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
    read_go_bit = Xil_In32(AES_b + REG_30_o);
    xil_printf("decfin_bit   [e]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
#endif

    while(1) {
        done_bit = Xil_In32(AES_b + REG_30_o) & 0x1; // poll finished bit
        if (done_bit == 1) {
            #ifdef FNI_HW_AES_DEBUG
            read_go_bit = Xil_In32(AES_b + REG_25_o);
            xil_printf("decstart_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x0, read_go_bit);
            xil_printf("Encryption Finished \r\n");
            #endif
            Xil_Out32(AES_b + REG_25_o, 0x0); // lower bit
            break;
        } else {
            //Xil_Out32(AES_b + REG_25_o, 0x0); // lower bit
        	continue;
			#ifdef FNI_HW_AES_DEBUG
				read_go_bit = Xil_In32(AES_b + REG_25_o);
				xil_printf("decstart_bit [w]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x0, read_go_bit);
				read_go_bit = Xil_In32(AES_b + REG_30_o);
				xil_printf("decfin_bit   [e]|[r] = 0x%08X | 0x%08X (%u) \n\r", 0x1, read_go_bit);
			#endif
        }
    }
    return 0;

}

void hw_aes_write_dec_data(u32 data_word11, u32 data_word10, u32 data_word9, u32 data_word8){
    Xil_Out32(AES_b + REG_21_o, data_word8);
    Xil_Out32(AES_b + REG_22_o, data_word9);
    Xil_Out32(AES_b + REG_23_o, data_word10);
    Xil_Out32(AES_b + REG_24_o, data_word11);
	return;
}


void hw_aes_decrypt(uint8_t* buf){
	u32 data_words[4];
	hw_aes_write_dec_data(u8_to_u32(&buf[0]),
					   	  u8_to_u32(&buf[4]),
						  u8_to_u32(&buf[8]),
						  u8_to_u32(&buf[12])
					   	  );
	hw_aes_start_dec(); //polls and blocks until completed
	data_words[0] = Xil_In32(AES_b + REG_29_o);
	data_words[1] = Xil_In32(AES_b + REG_28_o);
	data_words[2] = Xil_In32(AES_b + REG_27_o);
	data_words[3] = Xil_In32(AES_b + REG_26_o);
	for(int i = 0; i < 4; i++){
		buf[i*4] =   (data_words[i] & 0xFF000000) >> 24;
		buf[i*4+1] = (data_words[i] & 0x00FF0000) >> 16;
		buf[i*4+2] = (data_words[i] & 0x0000FF00) >> 8;
		buf[i*4+3] = (data_words[i] & 0x000000FF);
	}
	return;
}

/** Private Function Prototypes **/
// static u32 u8_to_u32(uint8_t* input);
// static void fni_aes_write_key(u32 key_word7, u32 key_word6, u32 key_word5, u32 key_word4,
//         					  u32 key_word3, u32 key_word2, u32 key_word1, u32 key_word0);
// static void fni_aes_write_data(u32 data_word11, u32 data_word10, u32 data_word9, u32 data_word8);
// static int fni_aes_start_hw();


/*********************************************************************/
/* Traditionally, all values need to                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

/** Public Function Definitions **/

/*
void fni_hw_aes_init(uint8_t* key){

	fni_aes_write_key(u8_to_u32(&key[0]),
				   	  u8_to_u32(&key[4]),
					  u8_to_u32(&key[8]),
					  u8_to_u32(&key[12]),
					  u8_to_u32(&key[16]),
					  u8_to_u32(&key[20]),
					  u8_to_u32(&key[24]),
					  u8_to_u32(&key[28])
					 );

	return;
}

void fni_hw_aes_encrypt(uint8_t* in_buf){
	u32 data_words[4];
	fni_aes_write_data(u8_to_u32(&in_buf[0]),
					   u8_to_u32(&in_buf[4]),
					   u8_to_u32(&in_buf[8]),
					   u8_to_u32(&in_buf[12])
					   );
	fni_aes_start_hw(); //polls and blocks until completed
	data_words[0] = Xil_In32(AES_b + REG_16_o);
	data_words[1] = Xil_In32(AES_b + REG_15_o);
	data_words[2] = Xil_In32(AES_b + REG_14_o);
	data_words[3] = Xil_In32(AES_b + REG_13_o);
	for(int i = 0; i < 4; i++){
		in_buf[i*4] =   (data_words[i] & 0xFF000000) >> 24;
		in_buf[i*4+1] = (data_words[i] & 0x00FF0000) >> 16;
		in_buf[i*4+2] = (data_words[i] & 0x0000FF00) >> 8;
		in_buf[i*4+3] = (data_words[i] & 0x000000FF);
	}
	return;
}

void fni_hw_aes_decrypt(uint8_t* in_buf){
	u32* data_words = (u32 *) in_buf;
	fni_aes_write_data(data_words[3],
					   data_words[2],
					   data_words[1],
					   data_words[0]
					   );
	fni_aes_start_hw(); //polls and blocks until completed
	data_words[3] = Xil_In32(AES_b + REG_16_o);
	data_words[2] = Xil_In32(AES_b + REG_15_o);
	data_words[1] = Xil_In32(AES_b + REG_14_o);
	data_words[0] = Xil_In32(AES_b + REG_13_o);
	return;
}

*/

/** Private function definitions **/

/*
static u32 u8_to_u32(uint8_t* input){
	u32 msb, lmsb, hlsb, lsb;
	msb = (input[0] << 24) & 0xFF000000;
	lmsb = (input[1] << 16)& 0x00FF0000;
	hlsb = (input[2] << 8 )& 0x0000FF00;
	lsb = (input[3])       & 0x000000FF;


	return msb | lmsb | hlsb | lsb;
}



static void fni_aes_write_key(u32 key_word7, u32 key_word6, u32 key_word5, u32 key_word4,
        					 u32 key_word3, u32 key_word2, u32 key_word1, u32 key_word0)
{

    Xil_Out32(AES_b + REG_0_o, key_word0);
    Xil_Out32(AES_b + REG_1_o, key_word1);
    Xil_Out32(AES_b + REG_2_o, key_word2);
    Xil_Out32(AES_b + REG_3_o, key_word3);
    Xil_Out32(AES_b + REG_4_o, key_word4);
    Xil_Out32(AES_b + REG_5_o, key_word5);
    Xil_Out32(AES_b + REG_6_o, key_word6);
    Xil_Out32(AES_b + REG_7_o, key_word7);

#ifdef FNI_HW_AES_DEBUG
    xil_printf("\r\nfni_aes_write_key->checking registers against inputs:\r\n");
    u32 slv_reg0_rdata, slv_reg1_rdata, slv_reg2_rdata, slv_reg3_rdata;
    u32 slv_reg4_rdata, slv_reg5_rdata, slv_reg6_rdata, slv_reg7_rdata;

    slv_reg7_rdata = Xil_In32(AES_b + REG_7_o);
    xil_printf("Key word 7 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word7, slv_reg7_rdata);

    slv_reg6_rdata = Xil_In32(AES_b + REG_6_o);
    xil_printf("Key word 6 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word6, slv_reg6_rdata);

    slv_reg5_rdata = Xil_In32(AES_b + REG_5_o);
    xil_printf("Key word 5 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word5, slv_reg5_rdata);

    slv_reg4_rdata = Xil_In32(AES_b + REG_4_o);
    xil_printf("Key word 4 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word4, slv_reg4_rdata);

    slv_reg3_rdata = Xil_In32(AES_b + REG_3_o);
    xil_printf("Key word 3 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word3, slv_reg3_rdata);

    slv_reg2_rdata = Xil_In32(AES_b + REG_2_o);
    xil_printf("Key word 2 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word2, slv_reg2_rdata);

    slv_reg1_rdata = Xil_In32(AES_b + REG_1_o);
    xil_printf("Key word 1 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word1, slv_reg1_rdata);

    // Lowest word of key
    slv_reg0_rdata = Xil_In32(AES_b + REG_0_o);
    xil_printf("Key word 0 [w]|[r] = 0x%08X | 0x%08X \n\r", key_word0, slv_reg0_rdata);
    xil_printf("\r\n");
#endif

	return;
}

static void fni_aes_write_data(u32 data_word11, u32 data_word10, u32 data_word9, u32 data_word8){
    Xil_Out32(AES_b + REG_8_o, data_word8);
    Xil_Out32(AES_b + REG_9_o, data_word9);
    Xil_Out32(AES_b + REG_10_o, data_word10);
    Xil_Out32(AES_b + REG_11_o, data_word11);
	return;
}



*/
