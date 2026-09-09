// Generated from schemas/v1/spectrum.yaml — do not edit; regenerate.
export interface Spectrum {
  readonly type: "spectrum";
  readonly technique?: string;
  readonly params?: {

  };
  readonly peaks?: {
    position: string;
    intensity?: string;
    multiplicity?: string;
    assignment?: string;
  }[];
}
