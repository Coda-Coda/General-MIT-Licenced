(* This demonstrates one approach to defining equality for an inductive type which includes a list of its own type as an argument to one of its constructors, making use of a measure and the "Program" machinery. *)

Require Import List.
Import ListNotations.
Require Import Bool.
Require Import Program.
Require Import Lia.

Inductive foo :=
  | Bar (l : list foo)
  | Baz
.

Fixpoint sum_list (l : list nat) : nat :=
match l with  
  | [] => 0
  | h :: tl => h + sum_list tl
end.

Fixpoint count_bars_and_bazs (f : foo) : nat :=
  match f with
    | Bar l => sum_list (List.map count_bars_and_bazs l) + 1
    | Baz => 1
  end.

Lemma count_bars_and_bazs_min : forall (f : foo), count_bars_and_bazs f > 0.
Proof.
intros.
induction f.
- simpl. destruct l; lia.
- simpl. lia. 
Qed.

(* Here we use Coq's "Program" machinery, declaring the measure "(count_bars_and_bazs f1)" which we must afterwards prove is decreasing. Coq will create the appropriate proof obligations for us which we prove by invoking "Next Obligation.". *)
Program Fixpoint eqFoo (f1 f2 : foo) {measure (count_bars_and_bazs f1)} :=
  match f1,f2 with
  | Bar [],Bar [] => true
  | Bar (h1 :: tl),Bar (h1' ::tl') => eqFoo h1 h1' && eqFoo (Bar tl) (Bar tl')
  | Baz,Baz => true
  | _,_ => false
  end.
Next Obligation.
simpl in *.
lia.
Defined.
Next Obligation.
clear.
revert tl h1.
destruct tl.
 - intros. simpl. pose proof (count_bars_and_bazs_min h1). lia.
 - intros. simpl in *. pose proof (count_bars_and_bazs_min h1). lia.
Defined.
(* The tactics used for the remaining obligations are all identical. *)
Next Obligation.
split.
- intros. unfold not.
  intros. destruct H. discriminate.
- intros. unfold not.
  split.
  + intros. unfold not.
    intros. destruct H. discriminate.
  + intros. unfold not.
    intros. destruct H. discriminate.
Defined.
Next Obligation.
split.
- intros. unfold not.
  intros. destruct H. discriminate.
- intros. unfold not.
  split.
  + intros. unfold not.
    intros. destruct H. discriminate.
  + intros. unfold not.
    intros. destruct H. discriminate.
Defined.
Next Obligation.
split.
- intros. unfold not.
  intros. destruct H. discriminate.
- intros. unfold not.
  split.
  + intros. unfold not.
    intros. destruct H. discriminate.
  + intros. unfold not.
    intros. destruct H. discriminate.
Defined.
Next Obligation.
split.
- intros. unfold not.
  intros. destruct H. discriminate.
- intros. unfold not.
  split.
  + intros. unfold not.
    intros. destruct H. discriminate.
  + intros. unfold not.
    intros. destruct H. discriminate.
Defined.
Next Obligation.
split.
- intros. unfold not.
  intros. destruct H. discriminate.
- intros. unfold not.
  split.
  + intros. unfold not.
    intros. destruct H. discriminate.
  + intros. unfold not.
    intros. destruct H. discriminate.
Defined.

Check eqFoo.
