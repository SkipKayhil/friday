import { JSX, ComponentChildren } from "preact";

type RowClick<T> = (params: { row: T; columns?: Column<T>[] }) => unknown;

interface RowCol<T> {
  row: T;
  column: Column<T>;
}

export interface Column<T> {
  field: keyof T;
  headerName?: string;
  renderCell?: (params: RowCol<T>) => ComponentChildren;
}

const getColumnName = <T,>(column: Column<T>) =>
  column.headerName === undefined
    ? (column.field as string)
    : column.headerName;

function Cell<T>({ row, column }: RowCol<T>) {
  const cellContent = column.renderCell
    ? column.renderCell({ row, column })
    : (row[column.field] as any);

  return <td class="px-6 py-4 whitespace-nowrap">{cellContent}</td>;
}

interface RowProps<T> {
  row: T;
  columns: Column<T>[];
  onRowClick?: RowClick<T>;
}

function Row<T>({ row, columns, onRowClick }: RowProps<T>) {
  const rowClass = `${onRowClick ? "hover:bg-gray-100 cursor-pointer" : ""}`;

  return (
    <tr
      onClick={() => onRowClick && onRowClick({ row, columns })}
      class={rowClass}
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
          {rows.map((row) => (
            <Row row={row} columns={columns} onRowClick={onRowClick} />
          ))}
        </tbody>
      </table>
    </div>
  );
}
