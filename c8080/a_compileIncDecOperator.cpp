#include <stdafx.h>
#include "a.h"
#include "b.h"

void incDecBC(int step1) {
  for(;step1>0; step1--) out.inx(Assembler::BC);
  for(;step1<0; step1++) out.dcx(Assembler::BC);
}

void incDecDE(int step1) {
  for(;step1>0; step1--) out.inx(Assembler::DE);
  for(;step1<0; step1++) out.dcx(Assembler::DE);
}

void incDecHL(int step1) {
  for(;step1>0; step1--) out.inx(Assembler::HL);
  for(;step1<0; step1++) out.dcx(Assembler::HL);
}

// 7-8-2014 �������
bool compileIncDecOperator(NodeMonoOperator* no, const std::function<bool(int)>& result) {
  bool inc = (no->o == moIncVoid || no->o == moPostInc || no->o == moInc);

  // �������������� ������ ����������!
  if(no->a->nodeType != ntDeaddr) raise("compileIncDecOperator");
  auto var = no->a->cast<NodeDeaddr>()->var;

  // �� ������� ���� �������� 16 ������ ����������?
  int step16 = 1;
  if(no->dataType.addr) step16 = no->dataType.sizeElement();
  if(!inc) step16 = -step16;

  // *************************************************************************
  // * ����� ���� ����������� � ���, ��� �� ����� ��������� ������� INC, DEC *
  // * ��� ������������ �����������, ��� ��������� �� � �����������.         *
  // *************************************************************************

  // ��� ����������� ����������
  if(var->nodeType == ntConstS && var->cast<NodeConst>()->var->reg) {
    auto nc = var->cast<NodeConst>();
    // ��� 8 ������ ����������
    if(no->dataType.is8()) {
      // �� ���� ���������� ��� ��������� � ������������, � ���  ����� � ������� ��������, 
      // �� �� �������� � ������� � B, C.
      if(s.a.in == nc->var) {
        // ��������: i=5+j; i++; ���� i ����������� ����������, �� ��� ����� ��������� � ������������
        if(no->o==moIncVoid || no->o==moDecVoid || no->o==moInc || no->o==moDec) goto stdPath;
        saveRegAAndUsed();
      }
      // �� ������ ������, ���������� ����� ���� (���� �� ������) � ������ ���������
      if(s.de.in == nc->var) saveRegDEAndUsed();
      if(s.hl.in == nc->var) saveRegHLAndUsed();
      // ��� �������� ����� � B, C
      auto reg = toAsmReg8(nc->var->reg);
      switch(no->o) {
        case moIncVoid: out.inr(reg); return result(0);
        case moDecVoid: out.dcr(reg); return result(0);
        case moInc:     saveRegAAndUsed(); out.inr(reg).mov(Assembler::A, reg); return result(regA);
        case moDec:     saveRegAAndUsed(); out.dcr(reg).mov(Assembler::A, reg); return result(regA);
        // ���� �� ������� case moInc:     out.inr(reg); return result(nc->var->reg);
        // ���� �� ������� case moDec:     out.dcr(reg); return result(nc->var->reg);
        case moPostInc: saveRegAAndUsed(); out.mov(Assembler::A, reg).inr(reg); return result(regA);
        case moPostDec: saveRegAAndUsed(); out.mov(Assembler::A, reg).dcr(reg); return result(regA);
      }
      throw;
    }

    if(no->dataType.is16()) {
      auto nc = var->cast<NodeConst>();
      // �� ���� ���������� ��� ��������� � ������������, � ���  ����� � ������� ��������, 
      // �� �� �������� � ������� � BC.
      if(s.hl.in == nc->var) {
        // ��������: i=5+j; i++; ���� i ����������� ����������, �� ��� ����� ��������� � ������������
        if(no->o==moIncVoid || no->o==moDecVoid || no->o==moInc || no->o==moDec) goto stdPath;
        saveRegHLAndUsed();
      }
      // �� ������ ������, ���������� ����� ���� (���� �� ������) � ������ ���������
      if(s.de.in == nc->var) saveRegDEAndUsed();
      if(s.a.in  == nc->var) saveRegAAndUsed();
      // � ���� ���������� ���������� ����� ���� ���������� ������ �� ��������� BC
      if(nc->var->reg != regBC) throw;          
      // ��������
      switch(no->o) {
        case moIncVoid: case moDecVoid: incDecBC(step16); return result(0);        
        case moInc:     case moDec:     saveRegHLAndUsed(); incDecBC(step16); out.mov(Assembler::H, Assembler::B).mov(Assembler::L, Assembler::C); return result(regHL); //! ��� ����� ������� BC
        case moPostInc: case moPostDec: saveRegHLAndUsed(); out.mov(Assembler::H, Assembler::B).mov(Assembler::L, Assembler::C); incDecBC(step16); return result(regHL); //! ��� ����� ������� DE
      }
      throw;
    }
  }

stdPath:
  // *************************************************************************
  // * ����� �� ������� ���������� � ����������� ��������                    *
  // *************************************************************************

  // *** 8 ������ �������� ***

  if(no->dataType.is8()) {    
    // ����� ���������� �������� ������, � ��� �� ����������.
    if(var->nodeType == ntConstI) { //! ����� lxi h + inc m
      // ����� ���������� ��������
      auto constAddr = var->cast<NodeConst>();
      saveRegAAndUsed();
      out.lda(constAddr->value);
      if(inc) out.inr(Assembler::A); else out.dcr(Assembler::A);
      out.sta(constAddr->value);
      if(no->o==moDecVoid || no->o==moIncVoid) return result(0);
      if(no->o==moPostDec || no->o==moPostInc) { if(inc) out.dcr(Assembler::A); else out.inr(Assembler::A); }
      return result(regA);
    }
    // ����� ���������� �������� �������, ����� ����������
    if(var->nodeType==ntConstS) { //! ����� lxi h + inc m
      // ����� ���������� ��������
      auto constAddr = var->cast<NodeConst>();
      loadInAreal(constAddr->var); // �������� ������� A � �������� ���� ����������
      if(inc) out.inr(Assembler::A); else out.dcr(Assembler::A);
      s.a.changed = true; // ���������� ����������
      if(no->o==moDecVoid || no->o==moIncVoid) return result(0);
      if(no->o==moPostDec || no->o==moPostInc) { saveRegAAndUsed(); if(inc) out.dcr(Assembler::A); else out.inr(Assembler::A); }
      return result(regA);
    }
    // ����� ���������� �����������
    return compileVar(var, regHL, [&](int reg){
      int outReg=0;
      if(no->o==moPostDec || no->o==moPostInc) saveRegAAndUsed(), outReg=regA, out.mov(Assembler::A, Assembler::M); //! ������ �������?
      if(inc) out.inr(Assembler::M); else out.dcr(Assembler::M);
      if(no->o==moDec || no->o==moInc) saveRegAAndUsed(), outReg=regA, out.mov(Assembler::A, Assembler::M); //! ������ �������?
      return result(outReg);
    });
  }

  // *** 16 ������ �������� ***

  if(no->dataType.is16()) {
    // ����� ���������� �������� ������, � ��� �� ����������.
    if(var->nodeType==ntConstI) {
      auto constAddr = var->cast<NodeConst>();
      saveRegHLAndUsed();
      out.lhld(constAddr->value);
      incDecHL(step16);
      out.shld(constAddr->value);
      if(no->o==moDecVoid || no->o==moIncVoid) return result(0);
      if(no->o==moPostDec || no->o==moPostInc) incDecHL(-step16);
      out.xchg(); //! ����� ����������� ��� DE �������!!!
      return result(regHL);
    }
    // ����� ���������� �������� �������, ����� ����������
    if(var->nodeType==ntConstS) {      
      auto constAddr = var->cast<NodeConst>();
      loadInHLreal(constAddr->var); // �������� ������� HL � �������� ���� ����������
      s.hl.delta = -step16; // ���������� ����������
      s.hl.changed = true; // ���������� ����������
      if(no->o==moDecVoid || no->o==moIncVoid) return result(regNone);
      //! ���� �� ������ regHL, �� �� ������ ���� ����������! ���� ��� �� ����������.
      incDecHL(step16); s.hl.delta=0; 
      if(no->o==moPostDec || no->o==moPostInc) { saveRegHLAndUsed(); incDecHL(-step16); }
      return result(regHL);
    }
    // ����� ���������� �����������, ������� ��� ���� ���������
    return compileVar(var, regHL, [&](int reg){
      saveRegDEAndUsed(); // � ������ ����� � � BC
      out.mov(Assembler::E, Assembler::M).inx(Assembler::HL).mov(Assembler::D, Assembler::M);
      incDecDE(step16);
      out.mov(Assembler::M, Assembler::D).dcx(Assembler::HL).mov(Assembler::M, Assembler::E);
      if(no->o==moDecVoid || no->o==moIncVoid) result(0);
      if(no->o==moPostDec || no->o==moPostInc) incDecDE(-step16);
      out.xchg(); //! ����� ����������� ��� DE �������!!!
      return result(regHL);
    });
  }
    
  raise("compileIncDecOperator !8 && !16");
  throw;
}
