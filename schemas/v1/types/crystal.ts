// Generated from schemas/v1/crystal.yaml — do not edit; regenerate.
export interface Crystal {
  readonly type: "crystal";
  readonly name?: string;
  readonly a?: number;
  readonly b?: number;
  readonly c?: number;
  readonly alpha?: number;
  readonly beta?: number;
  readonly gamma?: number;
  readonly spacegroup?: string;
  readonly atoms?: Atom[];
}
