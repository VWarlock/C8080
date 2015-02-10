#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileSaveA(NodeVar* b, bool noResult, const std::function<bool(bool,int)>& result) {
  // ������������ � ++, --
  if(b->nodeType==ntConstI) {
    out.sta(b->cast<NodeConst>()->value);
    return result(false, regA);
  }

  if(b->nodeType==ntConstS && b->cast<NodeConst>()->var->reg==regBC) {
    out.stax(Assembler::BC);
    return result(false, regA);
  }

  // ���� ������, ���������� �� ���������������� ��� ��� ��������
  bool old_a_used  = s.a.used;  s.a.used = false;
  bool old_de_used = s.de.used; s.de.used = false;
     
  // ������� ��������� �
  int poly = out.size(); out.push(Assembler::PSW);
       
  // ����������� ����� � HL
  return compileVar(b, regHL, [&](int){
    // � �� ���� ��������, ���������� �� �����
    if(!s.a.used) {
      ChangeCode cc(poly, -TIMINGS_PUSH, Assembler::cNop);
      out.mov(Assembler::M, Assembler::A);              
      s.a.used  = true;
      s.de.used = old_de_used;
      return result(false, regA);
    }
    // � ���� ��������, �� �������� D, ��������� ����
    if(!s.de.used) {
      auto reg = Assembler::D; //@ ��������� ������ ����� � ����� �������
      ChangeCode cc(poly, TIMINGS_MOV_D_A-TIMINGS_PUSH, Assembler::cMOV, reg, Assembler::A); 
      out.mov(Assembler::M, reg);
      s.a.used  = true;
      s.de.used = true;
      if(noResult) return result(false, 0);
      out.mov(Assembler::A, reg);
      return result(false, regA);
    }
    // � ����
    //! � ������ �� � A!!!!
    out.pop(Assembler::PSW).mov(Assembler::M, Assembler::A); //@ �������� ������ ����� � ����� �������        
    s.a.used  = true;
    s.de.used = old_de_used;
    return result(false, regA);
  });
}

//-----------------------------------------------------------------------------
// �������������� ��� ���������� �������� HL �� ������

bool compileSaveHL(NodeVar* b, bool noResult, const std::function<bool(bool,int)>& result) {
  
  //! ��������� STAX B !!!

  // ������������ � ++, --
  if(b->nodeType==ntConstI) {
    out.shld(b->cast<NodeConst>()->value);
    return result(false, regHL);
  }
  // ����� ����� ���� XCHG, ������� ���� ��������� �������.
  saveRegs(regHL);
  // ������� ��������� HL
  int poly3 = out.size(); out.push(Assembler::HL);
  // ���� ���� ������, ���������� �� ���������������� ��� �������� HL � DE?
  bool old_deUsed = s.de.used; s.de.used = false;
  bool old_hlUsed = s.hl.used; s.hl.used = false;
  // ����������� ����� � HL
  return compileVar(b, regHL, [&](int inReg) { 
    if(!s.de.used) {
      ChangeCode cc(poly3, TIMINGS_XCHG-TIMINGS_PUSH, Assembler::cXCHG); // DE �� ������������, ��������� ����� ���
      out.mov(Assembler::M, Assembler::E).inx(Assembler::HL).mov(Assembler::M, Assembler::D); s.hl.delta++;
      s.de.used = true;
      s.hl.used = true;
      if(noResult) return result(false, 0);
      // ������ ��������� � DE. ��������� ��� � DE
      saveRegHLAndUsed();
      saveRegDEAndUsed();
      out.xchg();
      return result(false, regHL);
    }
    out.pop(Assembler::DE);
    out.mov(Assembler::M, Assembler::E).inx(Assembler::HL).mov(Assembler::M, Assembler::D); s.hl.delta++;        
    s.de.used = true;
    s.hl.used = true;
    if(noResult) return result(false, 0);
    // ������ ��������� � DE. ��������� ��� � DE
    saveRegHLAndUsed();
    saveRegDEAndUsed();
    out.xchg();
    return result(false, regHL);
  });
}
