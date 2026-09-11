// Generated from schemas/v1/molecule.yaml — do not edit; regenerate.
export interface Molecule {
  readonly type: "molecule";
  readonly nodes: (Molecule | Group | Bond | Atom)[];
  readonly coefficient?: string;
  readonly identifiers?: Identifier[];
}
