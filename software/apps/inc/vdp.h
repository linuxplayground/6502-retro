#define VDP_RAM 0x7f40
#define VDP_REG 0x7f41
#define VDP_CON_MODE 0x0A11
#define VDP_CON_WIDTH 0x0A12

extern void vdp_init();
extern void vdp_init_g2();
extern void __fastcall__ vdp_set_write_address(unsigned int addr);
extern void __fastcall__ vdp_set_read_address(unsigned int addr);
extern void vdp_wait();
extern void vdp_flush();
extern void __fastcall__ vdp_write_to_screen_xy(unsigned char x, unsigned char y, unsigned char c);
extern unsigned char __fastcall__ vdp_read_from_screen_xy(unsigned char x, unsigned char y);
