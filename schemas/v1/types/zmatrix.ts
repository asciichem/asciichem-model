// Generated from schemas/v1/zmatrix.yaml — do not edit; regenerate.
export interface ZMatrix {
  readonly type: "zmatrix";
  readonly rows?: {
    atom: string;
    ref1?: string;
    distance?: string;
    ref2?: string;
    angle?: string;
    ref3?: string;
    dihedral?: string;
  }[];
}
