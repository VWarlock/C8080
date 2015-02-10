#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileConvert(NodeConvert* nc, int canRegs, const std::function<bool(int)>& result) {
  // ������ ��������������� �� ����
  if(nc->var->dataType.getSize() == nc->dataType.getSize()) {
    return compileVar(nc->var, canRegs, result);
  }

  // �������� ���� �����
  bool to16 = nc->var->dataType.getSize()==8  && nc->dataType.getSize()==16;
  bool to8  = nc->var->dataType.getSize()==16 && nc->dataType.getSize()==8;
  assert(to16 || to8);

  // �� ����� ��������������� ����������� �� ������ ��������. �� ����� ����� �� ���������
  // �� ������ ������ ���� ��� �������� �� �����.
  if(nc->var->nodeType == ntDeaddr) {
    auto nd = nc->var->cast<NodeDeaddr>();

    // ���� ������ ���������� ��� � ��������, �� ������ lda addr + mov l, a + mvi h, 0 �� mov l, a + mvi h, 0
    if(nd->var->nodeType == ntConstS) {
      auto nc = nd->var->cast<NodeConst>();
      if(to16 && nc->var == s.a.in) {
        // ������ ������, ����� ����� �������� 16 ������ ���������� � 8 ������ ��������.
        if(canRegs & regA) return result(regA); //! ����� �����            
        // ��������� A � HL
        saveRegHLAndUsed();
        out.mov(Assembler::L, Assembler::A); //! ��� ��������� ���� ��� �� ������������� ��������� � DE
        out.mvi(Assembler::H, 0);            
        return result(regHL);
      }
      if(to8 && nc->var == s.hl.in) {
        // ��������� s.hl.delta. ������� � ��� � HL, ������� ������ �������� ���� �� ������.
        loadInHL(s.hl.in);
        // ��������� HL � A
        saveRegAAndUsed();
        out.mov(Assembler::A, Assembler::L); //! ��� ��������� ���� ��� �� ������������� ��������� � ������ ��������, ���� ��� ���� � canRegs
        return result(regA);
      }
      if(to8 && nc->var == s.de.in) {
        // ��������� inDE_delta. ������� � ��� � DE, ������� ������ �������� ���� �� ������.
        loadInDE(s.de.in);
        // ��������� HL � A
        saveRegAAndUsed();
        out.mov(Assembler::A, Assembler::E); //! ��� ��������� ���� ��� �� ������������� ��������� � ������ ��������, ���� ��� ���� � canRegs
        return result(regA);
      }
    }

    if(nd->var->nodeType==ntConstS && (!nd->var->cast<NodeConst>()->var || !nd->var->cast<NodeConst>()->var->reg)) { //! � ��� ���� �������� � ����� �� ��������?
      Set<CType> s(nc->var->dataType, nc->dataType);
      if(to8) {
        // ������ LHLD �� LDA
        return compileVar(nc->var, regA, [&](int) {
          return result(regA);
        });
      } else {
        // ������ LDA �� LHLD + MVI H, 0
        return compileVar(nc->var, regHL, [&](int) {
          out.mvi(Assembler::H, 0);
          return result(regHL);
        });
      }
    }
  }

  // ��� ����������� �������� (�� �������� ����������� �� ������)
  if(to16) {
    // ������� � ����� 8 ������ �������
    return compileVar(nc->var, regA|regB|regC|regD|regE|regH|regL, [&](int inReg) {
      // ���� ��������� ����� � ���������� ��������, ����� �������
      if(inReg & canRegs) return result(inReg); //! ����� �����            
      // ����� ����������� ������� HL //! � ������ ����?
      saveRegHLAndUsed();
      switch(inReg) {
        case regA: out.mov(Assembler::L, Assembler::A); break;
        case regB: out.mov(Assembler::L, Assembler::B); break;
        case regC: out.mov(Assembler::L, Assembler::C); break;
        case regD: out.mov(Assembler::L, Assembler::D); break;
        case regE: out.mov(Assembler::L, Assembler::E); break;
        case regH: out.mov(Assembler::L, Assembler::H); break;
        case regL: break;
        default: raise("compileNodeConvert 1");
      }      
      out.mvi(Assembler::H, 0); //! mvi(Assembler::H, 0) ����� �������� �� MOV A, R ��� R=0
      return result(regHL);
    });
  } else {
    // ������� � ����� 16 ������ �������
    return compileVar(nc->var, regBC|regDE|regHL, [&](int inReg) {
      // ���� ��������� ����� � ���������� ��������, ����� �������
      if(inReg & canRegs)  return result(inReg); //! ����� �����            
      // ����� ����������� ������� A //! � ������ ��������?
      saveRegAAndUsed();
      switch(inReg) {
        case regBC: out.mov(Assembler::A, Assembler::C); break;
        case regDE: out.mov(Assembler::A, Assembler::E); break;
        case regHL: out.mov(Assembler::A, Assembler::L); break;
        default: raise("compileNodeConvert 2");
      }
      return result(regA);
    });
  }
}
