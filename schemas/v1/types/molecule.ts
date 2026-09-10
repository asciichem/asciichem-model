// Generated from schemas/v1/molecule.yaml — do not edit; regenerate.
export interface Molecule {
  readonly type: "molecule";
  readonly nodes: (Atom | Bond | Group | Molecule)[];
  readonly coefficient?: string;
  readonly identifiers?: Identifier[];
}
