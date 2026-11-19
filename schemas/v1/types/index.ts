// Union of every node type in the v1 model.
export type Node =
  | Adduct
  | Atom
  | Bond
  | Calculation
  | Crystal
  | ElectronConfiguration
  | EmbeddedMath
  | Formula
  | Group
  | Identifier
  | Mechanism
  | Molecule
  | Name
  | Provenance
  | ReactionCascade
  | Reaction
  | Spectrum
  | SubstanceRecord
  | Text
  | ZMatrix;
