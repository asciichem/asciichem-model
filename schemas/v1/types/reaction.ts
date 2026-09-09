// Generated from schemas/v1/reaction.yaml — do not edit; regenerate.
export interface Reaction {
  readonly type: "reaction";
  readonly reactants: Molecule[];
  readonly products: Molecule[];
  readonly arrow?: "forward" | "reverse" | "equilibrium" | "resonance";
  readonly conditions?: {
    above?: string;
    below?: string;
  };
}
