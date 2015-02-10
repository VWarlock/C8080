#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileOperatorV2_16(NodeOperator* o, bool swap, NodeVar* a, NodeVar* b, const std::function<bool(bool, int)>& result) {
  // ����������� �������� � �������
  if(o->o==oAdd && b->nodeType==ntConstI && a->nodeType==ntDeaddr && a->cast<NodeDeaddr>()->var->nodeType==ntConstS && s.hl.tmp == a->cast<NodeDeaddr>()->var->cast<NodeConst>()->var) {
    return compileOperatorV2_16_const_add(o, swap, b->cast<NodeConst>(), result);
  }

  return compileVar(a, regHL, [&](int inReg){
    // � �������� ������� ��������� ������������ ������� BC � ��� ����� ����������� ��� ������ �������� �������.
    auto reg = b->isRegVar();
    if(reg!=regNone && o->o==oAdd) {
      return compileOperator2_16(o, !swap, toAsmReg16(reg), result);
    }

    // ���� ������ �������� ���������, ��������� � ��������������� � ������� D/DE. ��� ���� ��������� �������� �������.
    if(b->isConst()) return compileOperatorV2_16_const(o, swap, b->cast<NodeConst>(), result);

    // ���� ������ �������� �� ���������, ������, ����� �� ��� ��� ������� �������� A ��� DE
    s.de.used = false;
    // ����� ����� ���� XCHG, ������� ���� ��������� �������.
    saveRegHLAndUsed();
    // ������� ��������� � ��� HL
    int poly = out.size(); out.push(Assembler::HL);
    // �����������    
    return compileVar(b, regHL, [&](int inReg){
      // ��� ��� ��������� ���������� �����������      
      if(!s.de.used) {
        // ���� DE �� ������������, �� ��������� � ���
        ChangeCode cc(poly, TIMINGS_XCHG-TIMINGS_PUSH, Assembler::cXCHG);
        s.de.used = true;
        return compileOperator2_16(o, swap, Assembler::DE, result);
      } else {
        out.pop(Assembler::DE);
        s.de.used = true;
        return compileOperator2_16(o, swap, Assembler::DE, result);
      }
    });    
  });
}
