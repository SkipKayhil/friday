const getColumnName = (column) => column.headerName || column.field;

export function Table({ rows, columns }) {
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
          {rows.map((repo) => (
            <tr>
              {columns.map((column) => (
                <td class="px-6 py-4 whitespace-nowrap">
                  {repo[column.field]}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
