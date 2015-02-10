#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

// �������� 16-������ �����

void add16(int size_of, bool self) {
  // ���������
  Stack& as = stack[stack.size()-2];
  Stack& bs = stack[stack.size()-1];

  // ��������� ������� ���������
  if(size_of != 1) {
    switch(bs.place) {
      case pConst:    bs.value *= size_of; break; 
      case pConstStr: bs.name = "("+bs.name+")*"+i2s(size_of); break;
      default:        pushHL(); mulHL(size_of); popTmpHL();
    }
  }

  // �������� ���� ��������
  if(as.place==pConst && bs.place==pConst) {
    as.value += bs.value;
    asm_pop();
    return;
  }

  // �������� ���� �������� (����������� ������������)
  if((as.place==pConstStr || as.place==pConst) && (bs.place==pConstStr || bs.place==pConst)) {
    string av = as.place==pConstStr ? as.name : i2s(as.value);
    string bv = bs.place==pConstStr ? bs.name : i2s(bs.value);
    as.place = pConstStr;
    as.name = "("+av+")+("+bv+")";
    asm_pop();
    return;
  }

  // ���������+����������. ����������� INC, DEC
  if(!self && as.place==pConst && as.value>=-4 && as.value<=4) {
    int v = as.value;
    //bc().remark("�������� � ���������� "+i2s(v));
    pushHL();
    asm_pop(); // ��� ���� ���������
    for(;v<0; v++) bc().dec_hl(); for(;v>0; v--) bc().inc_hl();
    popTmpHL();
    return;
  }

  // ����������+���������. ����������� INC, DEC
  if(bs.place==pConst && bs.value>=-4 && bs.value<=4) {
    int v = bs.value;
    asm_pop(); // ��� ���� ���������

    // ����������� BC
    if(self && as.place==pBC) {
      bc().remark("�������� BC � ���������� "+i2s(v));
      for(;v<0; v++) bc().dec_bc(); for(;v>0; v--) bc().inc_bc();
      return;
    }

    // �������� � HL � �������� � ���  
    bc().remark("�������� � ���������� "+i2s(v));
    pushPeekHL(self);
    for(;v<0; v++) bc().dec_hl(); for(;v>0; v--) bc().inc_hl();
    popTmpPokeHL(self);
    return;
  }

  // ����������� BC
  if(as.place == pBC) {
    bc().remark("�������� � BC");
    pushHL();
    if(!self) asm_pop(); // ���� ��� ��������� BC, �� �� � ����������� ����� � ���������
    bc().add_hl_bc();
    popTmpPokeHL(self); // ��������� � BC ��� �������� � HL
    return;
  }

  // ����������� BC
  if(bs.place == pBC) {
    bc().remark("�������� � BC");
    asm_pop(); // � ����������� ����� ��� BC
    pushPeekHL(self);
    bc().add_hl_bc();
    popTmpPokeHL(self);
    return;
  }

  // ����������� ������
  bc().remark("��������");
  pushHLDE(/*������� HL DE �� �����*/true, /*���� ����������� �� ����*/self);
  bc().add_hl_de();
  popTmpPokeHL(self);
}
     