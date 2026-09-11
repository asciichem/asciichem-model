// Generated from schemas/v1/formula.yaml — do not edit; regenerate.
export interface Formula {
  readonly type: "formula";
  readonly nodes: (Molecule | Reaction | ReactionCascade | Group | Atom | Bond | ElectronConfiguration | EmbeddedMath | Text | Name | Identifier | Mechanism | Spectrum | Crystal | ZMatrix | Calculation)[];
}
