// Generated from schemas/v1/group.yaml — do not edit; regenerate.
export interface Group {
  readonly type: "group";
  readonly nodes: (Atom | Molecule | Group)[];
  readonly multiplicity?: string;
  readonly bracket?: "paren" | "square" | "brace";
}
