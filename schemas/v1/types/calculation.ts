// Generated from schemas/v1/calculation.yaml — do not edit; regenerate.
export interface Calculation {
  readonly type: "calculation";
  readonly method?: string;
  readonly basis?: string;
  readonly properties?: {
    title: string;
    value: string;
    units?: string;
    dictRef?: string;
    convention?: string;
  }[];
}
