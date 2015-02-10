#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

void set16() {
  // ���������
  Stack& as = stack[stack.size()-2];
  Stack& bs = stack[stack.size()-1];

  // ���� as==pHLRef16, �� ����� pushHL �� ������������

  if(as.place==pHLRef16 && bs.place==pBC) { 
    bc().ld_HL_c().inc_hl().ld_HL_b().dec_hl(); 
    erasei(stack, stack.size()-2);
    return; 
  }

  switch(as.place) {
    case pBC: pushBC(); return; // ld_bc_hl  //! ����������
    default: pushHL(); pokeHL(); return;
  }
}