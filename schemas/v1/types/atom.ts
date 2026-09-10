// Generated from schemas/v1/atom.yaml — do not edit; regenerate.
export interface Atom {
  readonly type: "atom";
  readonly element: string;
  readonly isotope?: string;
  readonly charge?: string;
  readonly subscript?: string;
  readonly oxidationState?: string;
  readonly lonePairs?: number;
  readonly radicalElectrons?: number;
  readonly ringClosures?: string;
}
