import { withBase } from './withBase';

// Whether `pathname` is on the given section - matches the section itself
// and any page nested under it
export function isActive(pathname: string, to: string): boolean {
  return pathname.startsWith(withBase(to));
}
