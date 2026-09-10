// Generated from schemas/v1/formula.yaml — do not edit; regenerate.
export interface Formula {
  readonly type: "formula";
  readonly nodes: (Atom | Molecule | Group | Bond | Reaction | ReactionCascade | ElectronConfiguration | EmbeddedMath | Text | Name | Identifier | Mechanism | Spectrum | Crystal | ZMatrix | Calculation)[];
}
