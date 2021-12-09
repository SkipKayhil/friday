import { JSX, FunctionComponent, ComponentChildren } from "preact";

type RowClick<T> = (params: { row: T; columns?: Column<T>[] }) => unknown;

interface RowCol<T> {
  row: T;
  column: Column<T>;
}

interface BaseColumn<T> {
  headerName?: string;
  renderCell?: FunctionComponent<RowCol<T>>;
}

interface BasicColumn<T> extends BaseColumn<T> {
  field: keyof T;
}

interface CustomColumn<T> extends BaseColumn<T> {
  field: string;
  renderCell: BaseColumn<T>["renderCell"];
}

export type Column<T> = BasicColumn<T> | CustomColumn<T>;

function getColumnName<T>(column: Column<T>) {
  return column.headerName === undefined
    ? (column.field as string)
    : column.headerName;
}

function Cell<T>({ row, column }: RowCol<T>) {
  // TODO: ts doesn't seem like its able to figure out that the type here should
  // be narrowed. Possibly same as #44401 fixed by #44771. It doesn't have a
  // milestone yet, so check in around TS 4.4.1+
  const cellContent =
    column.renderCell === undefined ? (
      (row[(column as BasicColumn<T>).field] as unknown as ComponentChildren)
    ) : (
      <column.renderCell row={row} column={column} />
    );

  return <td class="px-6 py-4 whitespace-nowrap">{cellContent}</td>;
}

interface RowProps<T> {
  row: T;
  columns: Column<T>[];
  onRowClick?: RowClick<T>;
}

function Row<T>({ row, columns, onRowClick }: RowProps<T>) {
  const rowClass = `${onRowClick ? "cursor-pointer" : ""}`;

  return (
    <tr
      onClick={() => onRowClick && onRowClick({ row, columns })}
      class={`hover:bg-gray-100 ${rowClass}`}
    >
      {columns.map((column) => (
        <Cell key={column.field} row={row} column={column} />
      ))}
    </tr>
  );
}

interface TableProps<T> {
  rows: T[];
  columns: Column<T>[];
  onRowClick?: RowClick<T>;
}

export function Table<T>({
  rows,
  columns,
  onRowClick,
}: TableProps<T>): JSX.Element {
  return (
    <div class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            {columns.map((column) => (
              <th
                key={column.field}
                scope="col"
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                {getColumnName(column)}
              </th>
            ))}
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          {rows.map((row, i) => (
            <Row key={i} row={row} columns={columns} onRowClick={onRowClick} />
          ))}
        </tbody>
      </table>
    </div>
  );
}
