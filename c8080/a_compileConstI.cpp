#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileConstI(NodeConst* nc, const std::function<bool(int)>& result) {
  if(nc->dataType.is8()) {
    //? assert(canRegs == regA);
    //! ����������� � �
    //! ����������� � �
    //! ����������� � D
    //! ����������� � E
    //! ����������� � H
    //! ����������� � L

    // ����������� INC, DEC, ADD A

    // ������� ��� �������� ��� ��������
    int v = nc->value & 0xFF;
    if(s.a.const_ && s.a.const_value == v) return result(regA);

    // �������� � ������� ��������
    bool ce = s.a.const_;
    int cv = s.a.const_value;
    saveRegAAndUsed();
    if(nc->value==0) out.alu(Assembler::XOR, Assembler::A);
    else if(ce && ((cv+1) & 0xFF) == v) out.inr(Assembler::A);
    else if(ce && ((cv-1) & 0xFF) == v) out.dcr(Assembler::A); //! �������� ��� ���������
    else if(ce && ((cv << 1) & 0xFF) == v) out.alu(Assembler::ADD, Assembler::A); //! �������� ��� ���������
    else if(ce && ((cv ^ 0xFF) & 0xFF) == v) out.cma(); //! �������� ��� ���������
    else out.mvi(Assembler::A, nc->value & 0xFF);
    s.a.const_ = true;
    s.a.const_value = nc->value & 0xFF;
    return result(regA);
  }

  if(nc->dataType.is16()) {
    //? assert(canRegs == regHL);
    //! ����������� � �C
    //! ����������� � DE

    // ����������� INC, DEC, ADD A

    // ������� ��� �������� ��� ��������
    if(s.hl.const_ && s.hl.const_value==nc->value) return result(regHL);

    //! ��� �������� �����������

    // �������� � ������� ��������
    saveRegHLAndUsed();
    out.lxi(Assembler::HL, nc->value & 0xFFFF);
    s.hl.const_ = true;
    s.hl.const_value = nc->value & 0xFFFF;
    return result(regHL);
  }

  raise("compileConstI !8 && !16");
  throw;
}
