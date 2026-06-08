# E1: Implementation of Lexical Analysis (Automaton and Regular Expression)

Facundo Gael Piñeiro González A01666626

---

## Description

The language used in this project is based on the Elven languages created by J. R. R. Tolkien for his Middle-earth universe. These languages were constructed with their own grammar and phonology, with Sindarin and Quenya being among the most developed and widely used. In particular, Sindarin is used in names of places, regions and for writing poetic and prose texts, making it suitable for modeling lexical recognition (Salo, 2004).

For this project, a finite subset of Sindarin words was selected:

**Nimrais, Nin, Numen, Naug, Nogoth, Naugrim, and Negyth.**

The language is defined over the following alphabet:

Σ = {a, e, g, h, i, m, n, o, r, s, t, u, y, N}

An alphabet is defined as a finite, non-empty set of symbols used to construct strings (Hopcroft et al., 2001). Any symbol outside this set is considered invalid.

The objective is to design a finite automaton that recognizes this language, translate it into an equivalent regular expression, and implement a lexical analyzer using Prolog. Finite automata are computational models used to recognize patterns in strings and are defined as the following 5-tuple:

A = (Q, Σ, δ, q0, F)

where Q is a finite set of states, Σ is the alphabet, δ is the transition function, q0 is the initial state, and F is the set of accepting states (Hopcroft et al., 2001).

A Non-deterministic Finite Automaton (NFA) differs in that its transition function can return a set of states instead of a single state, allowing multiple possible computation paths for the same input (Hopcroft et al., 2001).

In this project, a DFA was selected. Since the language consists of a finite and explicitly defined set of words, each word can be represented as a unique path in the automaton, which simplifies its design and implementation.

---

## Model

The automaton was built by assigning each word a path from the initial state. Common prefixes such as **"N"**, **"Ni"**, and **"Nau"** are shared to simplify the structure. When a word is a prefix of another (e.g., *Naug* and *Naugrim*), the intermediate state is marked as accepting.

### V1

<img width="1723" height="949" alt="DFA_v1" src="https://github.com/user-attachments/assets/1ab5d0a5-5af4-4aab-b214-da9a3f615c91" />

The first version used a single accepting state for all words. This caused ambiguity, since some states had more than one transition with the same symbol. Shorter words like *Naug* were not clearly accepted, and some transitions skipped steps, making the automaton harder to read. Due to these issues, the design needed to be improved.

### V2

<img width="1497" height="820" alt="DFA_v2" src="https://github.com/user-attachments/assets/487f0e7e-35a4-4bba-88ae-25365c0a29a2" />

The second version reorganizes the automaton into clearer paths. Multiple accepting states are used so each word is recognized at the correct point. Transitions follow a more ordered sequence, improving clarity. This version correctly represents the language and is easier to understand.


### Regular Expression

Another way to represent the automaton is through a regular expression. A regular expression is a formal notation used to describe sets of strings and is equivalent in expressive power to finite automata (Hopcroft et al., 2001).

Since the language is finite and consists of specific words, the equivalent regular expression can be constructed using the union (`|`) operator to enumerate all valid options.

The resulting expression is:

**(^n)(i(mrais|n)|umen|au(g|grim)|egyth|ogoth)**

---

## Implementation

The previously designed DFA must now be implemented in Prolog within the file **Sindarin.pl**. This implementation requires a separation between the DFA's structure and its execution. The resulting Prolog program is characterized by the following key components:

```prolog
  path(CurrentState, Symbol, NextState)
  ```
Defines the transitions of the automaton. Each fact represents a valid move between states for a given input symbol, directly encoding the DFA structure. The following table illustrates all of the possible transitions:

| Starting State | Input | Final State |
|---------------|-------|------------|
| q0  | n | q1  |
| q1  | i | q2  |
| q1  | u | q9  |
| q1  | o | q19 |
| q1  | e | q24 |
| q1  | a | q13 |
| q2  | n | q3  |
| q2  | m | q4  |
| q4  | r | q5  |
| q5  | a | q6  |
| q6  | i | q7  |
| q7  | s | q8  |
| q9  | m | q10 |
| q10 | e | q11 |
| q11 | n | q12 |
| q13 | u | q14 |
| q14 | g | q15 |
| q15 | r | q16 |
| q16 | i | q17 |
| q17 | m | q18 |
| q19 | g | q20 |
| q20 | o | q21 |
| q21 | t | q22 |
| q22 | h | q23 |
| q24 | g | q25 |
| q25 | y | q26 |
| q26 | t | q27 |
| q27 | h | q28 |

```prolog
  accepting_state(State)
  ```
Specifies the accepting states. A word is valid only if the automaton finishes in one of these states after processing all symbols.

```prolog
 run_automaton([], CurrentState)
  ```
Base case of the recursion. When no symbols remain, the automaton checks whether the current state is accepting.

```prolog
  run_automaton([Letter | Remaining], CurrentState)
  ```
Recursive case. Processes the input list one symbol at a time, using `path()` to move between states until the list is fully consumed.

```prolog
  check_word(Word)
  ```
Entry point of the program. It initializes the automaton from the initial state (`q0`) and allows words to be tested directly.

---

# Tests

To test the automaton, load `Sindarin.pl` in Prolog and run queries using "`check_word([]).`”. Each word must be represented as a list of symbols (n, e, a, etc.).

* Valid words (true)

```prolog
check_word([n, i, n]).
check_word([n, i, m, r, a, i, s]).
check_word([n, u, m, e, n]).
check_word([n, a, u, g]).
check_word([n, a, u, g, r, i, m]).
check_word([n, o, g, o, t, h]).
check_word([n, e, g, y, t, h]).
```

* Invalid words (false)

```prolog
check_word([n, i]).
check_word([n, a, u, g, x]).
check_word([2, o, g, o]).
check_word([', e, g, y]).
check_word([n, x]).
```

<img width="1857" height="832" alt="prolog_test" src="https://github.com/user-attachments/assets/e8e532c8-cfe5-4e60-b657-ae36e5b409fe" />

---

# Analysis

The implementation follows a linear evaluation of the input, processing one symbol at a time until the list is empty. Because of this, the time complexity is **O(n)**, where **n** is the length of the input. Each step is a continous transition lookup, so the overall behavior remains linear. The space complexity is also **O(n)** due to the recursive calls stored in the stack.

The chosen implementation separates the automaton structure `path()` from its execution `run_automaton()`. This makes the code easier to read and modify, since transitions can be adjusted without changing the evaluation logic.

One limitation of the program is that it only accepts inputs as lists instead of strings, which reduces usability. Additionally, the automaton is defined specifically for this language, so extending it requires manually adding new transitions.

In a language such as Python, the same automaton would be implemented differently:

- Transitions would be stored in a structure such as a dictionary instead of facts like `path()`, for example:
```python
path = {('q0', n): 'q1'}
```
- The execution would use a loop (e.g., for) instead of recursion, for example:
```python
for letter in word:
```
- The current state would be updated manually at each step, for example:
```python
current_state = path[(current_state, letter)]
```
- Explicit conditionals would be required to handle invalid transitions, for example:
```python
if (current_state, letter) not in path:
   return False
```

Despite these differences, the overall time complexity remains O(n), since each symbol is processed once. However, the Prolog implementation is more concise and closer to the theoretical model of an automaton, while the Python version requires a more explicit control flow.

---

# References

- Hopcroft, J. E., Motwani, R., & Ullman, J. D. (2001). Introduction to Automata Theory, Languages, and Computation (2nd ed.). Addison-Wesley.
- Salo, D. (2004). A Gateway to Sindarin: A Grammar of an Elvish Language from J.R.R. Tolkien’s Lord of the Rings. University of Utah Press.
