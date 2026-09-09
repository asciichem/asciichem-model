// Generated from schemas/v1/provenance.yaml — do not edit; regenerate.
export interface Provenance {
  readonly type: "provenance";
  readonly source: string;
  readonly retrievedAt: string;
  readonly sourceVersion?: string;
  readonly attribution?: string;
}
