# Apples Data

These data come from a classic long-term experiment conducted at the
East Malling Research Station, Kent, which is the centre for research
into apple growing in the U.K. Commercial apple trees consist of two
parts grafted together. The lowest part, the *rootstock*, largely
determines the size of the tree, while the upper part (the *scion*)
determines the fruit characteristics. Rootstocks propagated by cuttings
(i.e. asexually produced) were once thought to result in smaller trees
than those propagated from seeds (i.e. sexually produced). This
hypothesis was re-examined in an experiment begun in 1918. Several trees
of each type of 16 types of rootstock were planted, all trees having the
same scion. Rootstocks I-IX were asexually produced, while X-XVI were
sexually produced. In the winter of 1933-4 a number of trees were
removed to make room for more, and the data presented here consists of
the above-ground weights of 104 trees felled in this period. No trees of
types VIII, XI or XIV were felled. The description is adapted from Lee
(1994). The data are from Andrews and Herzberg (1985).

## Format

The data consist of a data frame with 104 observations on 4 variables.

- Rootstock:

  Factor giving the rootstock type (I, II, III, IV, IX, V, VI, VII, X,
  XII, XIII, XV, XVI).

- Weight:

  Integer Above-ground weight of tree (pounds, lb).

- Weight_kg:

  Numeric Above-ground weight of tree (kilograms, kg);
  `Weight_kg = Weight * 0.45359237`.

- Propagated:

  Factor giving the propagation method (cutting, seed).

## References

Andrews, D. F. and Herzberg, A. M. (1985). *Data: A Collection of
Problems from Many Fields for the Student and Research Worker*. New
York: Springer.

Lee, A. J. (1994). *Data Analysis: An Introduction Based on R*.
University of Auckland.
