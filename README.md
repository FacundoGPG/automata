# E1: Implementation of Lexical Analysis (Automaton and Regular Expression)

Facundo Gael Piñeiro González A01666626

---


## Description

The language used in this project is based on the Elven languages created by J. R. R. Tolkien for his Middle-earth universe. These languages were constructed with their own grammar and phonology, with Sindarin and Quenya being among the most developed and widely used (Salo, 2004). In particular, Sindarin is used in names of places, regions and for writing poetic and prose texts, making it suitable for modeling lexical recognition.

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

### Version 1.0

![Version 1.0 Automaton](image_v1_placeholder.png)

The first version used a single accepting state for all words. This caused ambiguity, since some states had more than one transition with the same symbol. Shorter words like *Naug* were not clearly accepted, and some transitions skipped steps, making the automaton harder to read. Due to these issues, the design needed to be improved.

### Version 2.0

![Version 2.0 Automaton](image_v2_placeholder.png)

The second version reorganizes the automaton into clearer paths. Multiple accepting states are used so each word is recognized at the correct point. Transitions follow a more ordered sequence, improving clarity. This version correctly represents the language and is easier to understand.


### Regular Expression

Another way to represent the automaton is through a regular expression. A regular expression is a formal notation used to describe sets of strings and is equivalent in expressive power to finite automata (Hopcroft et al., 2001).

Since the language is finite and consists of specific words, the equivalent regular expression can be constructed using the union (`|`) operator to enumerate all valid options.

The resulting expression is:

(^N)(i(mrais|n)|umen|au(g|grim)|egyth|ogoth)


---


## Implementation

The previously designed DFA must now be implemented in Prolog within the file **Sindarin.pl**. This implementation requires a separation between the DFA's structure and its execution. The resulting Prolog program is characterized by the following key components:

`path(CurrentState, Symbol, NextState)`
Defines the transitions of the automaton. Each fact represents a valid move between states for a given input symbol, directly encoding the DFA structure.

### `accepting_state(State)`
Specifies the accepting states. A word is valid only if the automaton finishes in one of these states after processing all symbols.

### `run_automaton([], CurrentState)`
Base case of the recursion. When no symbols remain, the automaton checks whether the current state is accepting.

### `run_automaton([Letter | Remaining], CurrentState)`
Recursive case. Processes the input list one symbol at a time, using `path()` to move between states until the list is fully consumed.

### `check_word(Word)`
Entry point of the program. It initializes the automaton from the initial state (`q0`) and allows words to be tested directly.

---

# Test

To test the automaton, load `Sindarin.pl` in Prolog and run queries using:
