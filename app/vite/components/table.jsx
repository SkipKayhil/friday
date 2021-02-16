const getColumnName = (column) => column.headerName || column.field;

function Cell({ row, column }) {
  const cellContent = column.renderCell
    ? column.renderCell({ row, column })
    : row[column.field];

  return <td class="px-6 py-4 whitespace-nowrap">{cellContent}</td>;
}

function Row({ row, columns, onRowClick }) {
  const rowClass = `${onRowClick ? "hover:bg-gray-100 cursor-pointer" : ""}`;

  return (
    <tr onClick={() => onRowClick({ row, columns })} class={rowClass}>
      {columns.map((column) => (
        <Cell row={row} column={column} />
      ))}
    </tr>
  );
}

export function Table({ rows, columns, onRowClick }) {
  return (
    <div class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            {columns.map((column) => (
              <th
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
