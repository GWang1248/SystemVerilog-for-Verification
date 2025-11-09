#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>

typedef struct {
    uint32_t reg;
} ShiftInstance;

static unsigned int call_count = 0;

ShiftInstance* shift_new(uint32_t init_val) {
    ShiftInstance* s = (ShiftInstance*)malloc(sizeof(ShiftInstance));
    s->reg = init_val;
    printf("[C] Created instance %p with init = 0x%08x\n", (void*)s, s->reg);
    return s;
}

void shift_free(ShiftInstance* s) {
    printf("[C] Free instance %p (final reg = 0x%08x)\n", (void*)s, s->reg);
    free (s);
}

uint32_t shift_c (ShiftInstance* s, uint32_t i, int n, bool ld) {
    call_count++;

    if (ld) {
        if (n > 0)
            s->reg = i << n;
        else if (n < 0)
            s->reg = i >> (-n);
        else
            s->reg = i;
    }
    else {
        if (n > 0)
            s->reg <<= n;
        else if (n < 0)
            s->reg >>= (-n);
    }
    printf("[C] #%u call @%p: i = %08x n = %d ld = %d -> reg = %08x\n", call_count, (void*)s, i, n, ld, s->reg);
    return s->reg;
}