#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileOperatorV2_8(NodeOperator* o, bool swap, NodeVar* a, NodeVar* b, const std::function<bool(bool, int)>& result) {
  // �������� B,C ����� ���������� � ����� ��� ������� ������� ��������  
  if((o->o==oE || o->o==oNE) && b->nodeType==ntConstI && b->cast<NodeConst>()->value==0) {
    auto reg = a->isRegVar();
    if(s.a.in && s.a.in->reg!=reg) { // ������ ���� ���������� �� � ������������!
      if(reg!=regNone) {
        auto r = toAsmReg8(reg);
        if(!zFlagFor8(r)) out.dcr(r).inr(r);
        return result(swap, regNone);
      }
    }
  }     

  return compileVar(a, regA, [&](int inReg){
    // � �������� ������� ��������� ������������ ������� B ��� C � ��� ����� ����������� ��� ������ �������� �������.
    auto reg = b->isRegVar();
    if(reg!=regNone && compileOperator2_8_checkAnyReg(o)) {
      return compileOperator2_8(o, !swap, toAsmReg8(reg), result);
    }

    // ���� ������ �������� ���������, ��������� � ��������������� � ������� D. ��� ���� ��������� �������� �������.
    // ������� compileOperatorV2_8_const ����������� SWAP, ������� ���� ������!
    if(b->isConst() && !(swap && o->o==oSub)) return compileOperatorV2_8_const(o, swap, b->cast<NodeConst>(), result);

    // ���� ������ �������� �� ���������, ������, ����� �� ��� ��� ������� �������� A ��� DE
    s.de.used = false;
    // ������� ��������� � ��� HL
    int poly = out.size(); out.push(Assembler::PSW);
    // �����������    
    return compileVar(b, regA, [&](int inReg){
      // ��� ��� ��������� ���������� �����������      
      if(!s.de.used) { //! �������� D � E
        // ���� DE �� ������������, �� ��������� � ���
        ChangeCode cc(poly, TIMINGS_MOV_D_A-TIMINGS_PUSH, Assembler::cMOV, Assembler::D, Assembler::A);
        s.de.used = true;
        return compileOperator2_8(o, swap, Assembler::D, result);
      }
      out.pop(Assembler::DE);
      s.de.used = true;
      return compileOperator2_8(o, swap, Assembler::D, result);
    });      
  });    
}
