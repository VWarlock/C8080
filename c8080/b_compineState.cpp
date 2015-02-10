#include <stdafx.h>
#include "b.h"

int combineState_r(State::Reg& s, const State::Reg& saved) {
  // ���������� �������� ������ ��������
  if(s.const_value != saved.const_value || !saved.const_) s.const_ = false; 

  // ��������� �������� ������ ��������
  if(s.tmp != saved.tmp) s.tmp = 0; 

  if(saved.in && saved.changed) { // ���� �� ������ ����� � ��� � �������� ������������� ����������.
    if(s.in!=saved.in || s.delta!=saved.delta) return 2; // �� � �������� ����� ������ ���� �� �� ���������, ����� ���������� ����������. //! � ����� � ���������
    s.changed = true; // ������, � ������� ����� ��� ����� ���� ��� �����������. �� ��������������� �������.
    return 0;
  }

  // ���� � �������� ����� � ��� � �������� ������������� ����������.
  if(s.in && s.changed) {
    if(s.in==saved.in && s.delta==saved.delta) return 0; // � �� ������ ���� ����� �� ����������, ������ �������
    // ��������� 
    return 1;
  }

  // �� ����������� �������� ���
  return 0;
}

bool combineState_(const State& saved) {
  switch(combineState_r(s.a, saved.a )) {
    case 2: return false;
    case 1: saveRegAAndUsed();
  }
  switch(combineState_r(s.de, saved.de)) {
    case 2: return false;
    case 1: saveRegDEAndUsed();
  }
  switch(combineState_r(s.hl, saved.hl)) {
    case 2: return false;
    case 1: saveRegHLAndUsed();
  }
  return true;
}
