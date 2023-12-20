/**
 * @param {number} length
 * @param {number} start
 * @returns {number[]}
 */
export function range(length, start = 0) {
  return Array.from({ length }, (_, i) => i + start);
}
