#include <stdafx.h>
#include "a.h"
#include "b.h"

bool compileOperatorV2_8_const(NodeOperator* o, bool swap, NodeConst* bc, const std::function<bool(bool, int)>& result) {  
  switch(o->o) {
    case oE: case oNE: // ��������� � �����, ��������� � ������

      // ���� ���� �������� � ����� 
      if(bc->nodeType==ntConstI && (bc->value&0xFF) == 0) {
        // ���� ������� ������� �������� ���� � ������������� � A, �� OR A �� ���������
        if(!zFlagForA()) out.alu(Assembler::OR, Assembler::A);
        return result(swap, 0);      
      }     

      // ���� ���� �������� � ��������. //! ������� ������� A ����� ���� �� �������
      if(bc->nodeType==ntConstI && (bc->value&0xFF) == 1) {
        saveRegAAndUsed();
        out.dcr(Assembler::A); //! ���� �������� ��� �����!
        return result(swap, 0);      
      }     

      // ���� ���� �������� � �����. //! ������� ������� A ����� ���� �� �������
      if(bc->nodeType==ntConstI && (bc->value&0xFF) == 255) {
        saveRegAAndUsed();
        out.inr(Assembler::A); //! ���� �������� ��� �����!
        return result(swap, 0);      
      }     

      // ���������� c �������� CPIn
    case oGE: case oLE: case oG: case oL:
      out.alui(Assembler::CMP, bc);
      return result(!swap, 0);
    case oXor: { saveRegAAndUsed(); out.alui(Assembler::XOR, bc); return result(swap, regA); }
    case oAnd: { saveRegAAndUsed(); out.alui(Assembler::AND, bc); return result(swap, regA); }
    case oOr:  { saveRegAAndUsed(); out.alui(Assembler::OR,  bc); return result(swap, regA); }
    // oSub �� ������������, ��� ��� ���������� �� oAdd        
    case oSub:
      raise("�� ������ ���� SUB!");
    case oAdd: { 
      saveRegAAndUsed();
      if(bc->nodeType==ntConstI && (bc->value & 0xFF)==1) out.inr(Assembler::A); 
      else if(bc->nodeType==ntConstI && (bc->value & 0xFF)==255) out.dcr(Assembler::A); 
      else out.alui(Assembler::ADD, bc);
      return result(swap, regA);
    }    
    case oShl: {
      saveRegAAndUsed();
      for(unsigned char x = bc->value; x>0; x--) 
        out.alu(Assembler::ADD, Assembler::A);
      return result(false, regA); 
    }
    case oShr: {
      saveRegAAndUsed();
      unsigned char mask = 0xFF;
      for(unsigned char x = bc->value; x>0; x--) {
        out.rrc();
        mask >>= 1;
      }
      out.alui(Assembler::AND, mask);
      return result(false, regA); 
    }
    //! �������� ������� �� 1,2,4,8,16,32,64,128
    case oMul: {
      if(((unsigned char)bc->value) > 1) {
        saveRegAAndUsed();

        char mask[64];
        char* m = mask;
        bool needSaveD = false;
        for(unsigned int d = bc->value; d>1; d>>=1)
          if(*m++ = (d & 1))
            needSaveD = true;

        // ����� D
        if(needSaveD) {
          saveRegDEAndUsed(); // ��� �������, ����� � � ����. � ����� ��������, ��� A ������ � D!
          out.mov(Assembler::D, Assembler::A);
        }

        while(m != mask) {
          m--;
          out.alu(Assembler::ADD, Assembler::A);      
          if(*m) out.alu(Assembler::ADD, Assembler::D);
        }

        return result(false, regA); 
      }
    }
  }

  // ��������� ��������� ����� � D ��� DE.
  //! ����������� ��� � B,C,D,E,H,L
  return loadInDE(bc, false, [&](){
    return compileOperator2_8(o, !swap, Assembler::D, result);
  });
}
