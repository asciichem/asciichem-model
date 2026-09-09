// Generated from schemas/v1/substance-record.yaml — do not edit; regenerate.
export interface SubstanceRecord {
  readonly type: "substance-record";
  readonly preferredName?: string;
  readonly synonyms?: string[];
  readonly formula?: string;
  readonly molecularWeight?: number;
  readonly identifiers: {
    identifier: Identifier;
    provenance: Provenance;
  }[];
  readonly properties?: {
    name: string;
    value: string;
    units?: string;
    provenance: Provenance;
  }[];
}
