#include <stdafx.h>
#include "stackLoadSave.h"
#include "asm.h"

void resultFlags(CType& out, CBaseType t) {
  add(stack).place = pFlags;
  out.baseType = t; 
}

// ��������� 16 ������� �������� � ����������

char cmpImm16(CBaseType t, CBaseType t1, CType& a, int delta, int delta2) {
  // ���������
  Stack& as = stack[stack.size()-2];
  Stack& bs = stack[stack.size()-1];

  // ����� � �������������� ���������
  if(as.place==pConst   ) as.value = -as.value+delta2; else
  if(as.place==pConstStr) { as.name  = "-("+as.name+")"; if(delta) as.name += "+"+i2s(delta2); } else
  if(bs.place==pConst   ) bs.value = -bs.value+delta, t = t1; else
  if(bs.place==pConstStr) { bs.name  = "-("+bs.name+")"; if(delta) bs.name += "+"+i2s(delta); t = t1; } else return false;

  // ��������, ��������� � HL
  add16(1);
  pushHL();

  // ���� ��������� == ��� !=, �� ���������� ���������� ���� Z
  if(t==cbtFlagsE || t==cbtFlagsNE) bc().ld_a_l().or_h(); 

  // ��������� �� ������
  resultFlags(a, t);
 
  // ��������� ��������
  return true;
} 
