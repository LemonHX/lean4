/-
Copyright (c) 2016 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Leonardo de Moura
-/
prelude
import Init.Data.Nat.Div
import Init.Data.Nat.Bitwise
import Init.Coe

open Nat

namespace Fin

instance coeToNat {n} : Coe (Fin n) Nat :=
  ⟨fun v => v.val⟩

def elim0.{u} {α : Sort u} : Fin 0 → α
  | ⟨_, h⟩ => absurd h (notLtZero _)

variable {n : Nat}

protected def ofNat {n : Nat} (a : Nat) : Fin (succ n) :=
  ⟨a % succ n, Nat.modLt _ (Nat.zeroLtSucc _)⟩

protected def ofNat' {n : Nat} (a : Nat) (h : n > 0) : Fin n :=
  ⟨a % n, Nat.modLt _ h⟩

private theorem mlt {b : Nat} : {a : Nat} → a < n → b % n < n
  | 0,   h => Nat.modLt _ h
  | a+1, h =>
    have n > 0 from Nat.ltTrans (Nat.zeroLtSucc _) h;
    Nat.modLt _ this

protected def add : Fin n → Fin n → Fin n
  | ⟨a, h⟩, ⟨b, _⟩ => ⟨(a + b) % n, mlt h⟩

protected def mul : Fin n → Fin n → Fin n
  | ⟨a, h⟩, ⟨b, _⟩ => ⟨(a * b) % n, mlt h⟩

protected def sub : Fin n → Fin n → Fin n
  | ⟨a, h⟩, ⟨b, _⟩ => ⟨(a + (n - b)) % n, mlt h⟩

/-
Remark: mod/div/modn/land/lor can be defined without using (% n), but
we are trying to minimize the number of Nat theorems
needed to boostrap Lean.
-/

protected def mod : Fin n → Fin n → Fin n
  | ⟨a, h⟩, ⟨b, _⟩ => ⟨(a % b) % n, mlt h⟩

protected def div : Fin n → Fin n → Fin n
  | ⟨a, h⟩, ⟨b, _⟩ => ⟨(a / b) % n, mlt h⟩

protected def modn : Fin n → Nat → Fin n
  | ⟨a, h⟩, m => ⟨(a % m) % n, mlt h⟩

def land : Fin n → Fin n → Fin n
  | ⟨a, h⟩, ⟨b, _⟩ => ⟨(Nat.land a b) % n, mlt h⟩

def lor : Fin n → Fin n → Fin n
  | ⟨a, h⟩, ⟨b, _⟩ => ⟨(Nat.lor a b) % n, mlt h⟩

instance : Add (Fin n) where
  add := Fin.add

instance : Sub (Fin n) where
  sub := Fin.sub

instance : Mul (Fin n) where
  mul := Fin.mul

instance : Mod (Fin n) where
  mod := Fin.mod

instance : Div (Fin n) where
  div := Fin.div

instance : HMod (Fin n) Nat (Fin n) where
  hMod := Fin.modn

instance : OfNat (Fin (n+1)) i where
  ofNat := Fin.ofNat i

theorem vneOfNe {i j : Fin n} (h : i ≠ j) : val i ≠ val j :=
  fun h' => absurd (eqOfVeq h') h

theorem modnLt : ∀ {m : Nat} (i : Fin n), m > 0 → (i % m).val < m
  | m, ⟨a, h⟩, hp =>  Nat.ltOfLeOfLt (modLe _ _) (modLt _ hp)

end Fin

open Fin
