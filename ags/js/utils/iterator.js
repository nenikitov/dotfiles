/**
 * @param {number} length
 * @param {number} start
 * @returns {number[]}
 */
export function range(length, start = 0) {
  return Array.from({ length }, (_, i) => i + start);
}

/**
 * @template T
 * @template {keyof any} K
 * @param {T[]} array
 * @param {(e: T) => K} callback
 * @returns {Record<K, T[]>}
 */
export function groupBy(array, callback) {
  /** @type {Record<K, T[]>} */
  // @ts-expect-error (2322) - Isn't a record yet because it will be initialized
  const result = {};
  for (const e of array) {
    (result[callback(e)] ||= []).push(e);
  }
  return result;
}
