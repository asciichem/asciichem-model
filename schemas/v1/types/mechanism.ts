// Generated from schemas/v1/mechanism.yaml — do not edit; regenerate.
export interface Mechanism {
  readonly type: "mechanism";
  readonly steps?: {
    label?: string;
    reaction: Reaction;
    flows?: {
    source: string;
    target: string;
  }[];
  }[];
  readonly spectators?: Molecule[];
}
