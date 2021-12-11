import { JSX, ComponentChildren, VNode } from "preact";

type RowClick<T> = (params: { row: T; columns?: Column<T>[] }) => unknown;

interface RowCol<T> {
  row: T;
  column: Column<T>;
}

interface BaseColumn {
  headerName?: string;
}

interface BasicColumn<T> {
  field: keyof T;
}

interface CustomColumn<T> {
  field: string;
  renderCell: (props: RowCol<T>) => VNode | null;
}

export type Column<T> = BaseColumn & (BasicColumn<T> | CustomColumn<T>);

function getColumnName<T>(column: Column<T>) {
  return column.headerName === undefined
    ? (column.field as string)
    : column.headerName;
}

function Cell<T>({ row, column }: RowCol<T>) {
  const cellContent =
    "renderCell" in column ? (
      <column.renderCell row={row} column={column} />
    ) : (
      (row[column.field] as unknown as ComponentChildren)
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
