#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#include "vdp.h"
#include "conio.h"
#include "main.h"

uint8_t x, y, c, r, i, j = 0;

uint16_t addr = 0;
uint16_t seed = 0;
uint8_t grow = 2;
uint16_t score = 0;
uint8_t ticks = 0;
uint8_t game_speed = 12;
bool crashed = false;

uint8_t buffer[BUFFER_SIZE] = {0};
uint16_t buffer_head = 0;
uint16_t buffer_tail = 0;

struct {
    int8_t x;
    int8_t y;
    uint8_t dir;
} head;

struct {
    uint8_t x;
    uint8_t y;
} apple;

uint8_t tb[40];

void print_at_xy(uint8_t x, uint8_t y, uint8_t * s) {
        addr = 0x600 + (y*32) + x;
        do {
                *(char*)addr = *s;
                ++s;
                ++addr;
        } while (*s != 0);
}

void set_pattern_color(uint8_t pattern, uint8_t color) {
        vdp_set_write_address(pattern * 8 + VDP_COLOR_TABLE);
        for (i=0; i<8; ++i) {
                *(char*)VDP_RAM = color;
        }
}

void init_game() {
        vdp_init_g2();
        // Set all colours to grey on black.
        vdp_set_write_address(VDP_COLOR_TABLE);
        for(addr=0; addr<0x800; ++addr) {
                *(char*)VDP_RAM=0xe1;
        }

        //Set snake character colours
        set_pattern_color(head_up, 0x61);
        set_pattern_color(head_dn, 0x61);
        set_pattern_color(head_lt, 0x61);
        set_pattern_color(head_rt, 0x61);
        set_pattern_color(applechar,   0x21);
}

void print_center_y(uint8_t y, char * s) {
        uint8_t len = strlen(s);
        uint8_t x = 15-(len/2);
        print_at_xy(x,y,s);
}

void new_apple() {
        bool taken = true;
        while(taken) {
                x = (rand() % 32);
                y = (rand() % 24);
                if (vdp_read_from_screen_xy(x,y) == 0x20) {
                        taken = false;
                        apple.x = x;
                        apple.y = y;
                }
        }
        vdp_write_to_screen_xy(apple.x, apple.y, applechar);
        grow = 2;
}

uint8_t menu(void) {
        print_center_y(3, "SNAKE 6502 - V1.0");
        print_center_y(5, "BY PRODUCTION-DAVE");
        print_center_y(13,"PRESS ANY KEY TO PLAY");

        sprintf(tb, "SCORE: %d", score);
        print_center_y(7, tb);

        if (crashed == true) {
                print_center_y(23, "CRASHED");
        }

        vdp_wait();
        vdp_flush();
        seed = 0;
        do {
                c = cgetc_nw();
                ++seed;
        } while (c == 0);
        if (c == 0x1b) {
                return 0;
        } else {
                srand(seed);
                return 1;
        }
}

void new_game(void) {

        memset((uint8_t*)0x600,0x20,0x300);
        buffer_head = 0;
        buffer_tail = 0;
        head.x = 15;
        head.y = 20;
        head.dir = head_rt;
        game_speed = 8;
        ticks = 0;
        crashed = false;
        grow = 2;
        score = 0;
        new_apple();
        vdp_wait();
        vdp_flush();
}

void run(void) {
        do {
                if (ticks == game_speed) {
                        c = cgetc_nw();

                        if (c == 0x1b) {
                                crashed = true;
                                cputs("ESCAPE PRESSED");
                        } else if (c == 0xA1) {
                                if (head.dir != head_rt) head.dir = head_lt;
                        } else if (c == 0xA2) {
                                if (head.dir != head_lt) head.dir = head_rt;
                        } else if (c == 0xA3) {
                                if (head.dir != head_dn) head.dir = head_up;
                        } else if (c == 0xA4) {
                                if (head.dir != head_up) head.dir = head_dn;
                        }

                        if (head.dir == head_lt) {
                                head.x--;
                        } else if (head.dir == head_rt) {
                                head.x++;
                        } else if (head.dir == head_up) {
                                head.y--;
                        } else if (head.dir == head_dn) {
                                head.y++;
                        } else {
                                crashed = false;
                        }

                        if ( head.x < 0 || head.x > 31 ) {
                                crashed = true;
                                cputs("X Boundary\n");
                        }
                        if ( head.y < 0 || head.y > 23 ) {
                                crashed = true;
                                cputs("Y Boundary\n");
                        }

                        r = vdp_read_from_screen_xy(head.x, head.y);
                        if (r == applechar) {
                                score += 5;
                                new_apple();
                        } else if (r != 0x20) {
                                crashed = true;
                                cputs("HIT TAIL\n");
                        }
                        if (crashed == false) {
                                vdp_write_to_screen_xy(head.x, head.y, head.dir);
                                if (buffer_head > BUFFER_SIZE) {
                                        buffer_head = 0;
                                }
                                buffer[buffer_head] = head.x;
                                buffer[buffer_head+1] = head.y;
                                buffer_head += 2;

                                if (grow > 0) {
                                        grow --;
                                } else {
                                        vdp_write_to_screen_xy(buffer[buffer_tail], buffer[buffer_tail+1], 0x20);
                                        buffer_tail += 2;
                                        if (buffer_tail > BUFFER_SIZE) {
                                                buffer_tail = 0;
                                        }
                                }
                                vdp_wait();
                                vdp_flush();
                                ticks = 0;
                        }
                } else {
                        vdp_wait();
                        ticks ++;
                }

        } while (crashed == false);
}

void main(void) {
        init_game();
        sprintf(tb, "Free memory: %d\n", _heapmemavail());
        cputs(tb);
        while(1) {
                if( !menu() ) {
                        break;
                } else {
                        new_game();
                        run();
                }
        }
}