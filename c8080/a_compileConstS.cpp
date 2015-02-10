#include <stdafx.h>
#include "a.h"
#include "b.h"

// ��������� ����� ���������� � �����������. �������� ���������� ����������, �����
// NodeConstS �������� � NodeDeaddr. compileConstS ��� ���� �� ����������.

bool compileConstS(NodeConst* nc, int canRegs, const std::function<bool(int)>& result) {
  if(nc->var->reg) raise("� ����������� ���������� ��� ������!\n" + nc->var->name);

  if(nc->dataType.is8()) {
    saveRegAAndUsed();
    //! � ����� ��� ���������? ��� �������� ����������� ����
    //! ������� � ��������� ��������
    out.mvi(Assembler::A, nc->var->name.c_str());
    return result(regA); 
  }

  if(nc->dataType.is16()) {
    saveRegHLAndUsed();
    //! � ����� ��� ���������? ��� ��������� ����������� ����
    //! ������� � ��������� ��������
    out.lxi(Assembler::HL, nc->var->name.c_str());
    return result(regHL);
  }

  raise("compileConstS !8 && !16");
  throw;
}