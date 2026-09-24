import { useEffect, useState } from 'react';

// https://usehooks.com/useOnScreen/
export function useOnScreen<T extends Element>(
  ref: React.RefObject<T | null>,
  rootMargin = '0px'
) {
  const [isIntersecting, setIsIntersecting] = useState(false);

  useEffect(() => {
    const el = ref.current;
    const observer = new IntersectionObserver(
      ([entry]) => {
        setIsIntersecting(entry.isIntersecting);
      },
      { rootMargin }
    );

    if (el) observer.observe(el);

    return () => {
      observer.disconnect();
    };
  }, [ref, rootMargin]);

  return isIntersecting;
}
