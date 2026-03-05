import { useState, useEffect, useCallback } from 'react';
import type { Child } from '../models/types';
import {
  getAllChildren,
  insertChild,
  updateChild,
  deleteChild,
} from '../db/child-repository';

export function useChildren() {
  const [children, setChildren] = useState<Child[]>([]);

  const refreshChildren = useCallback(() => {
    setChildren(getAllChildren());
  }, []);

  useEffect(() => {
    refreshChildren();
  }, [refreshChildren]);

  const addChild = useCallback(
    (data: Omit<Child, 'id' | 'createdAt'>): Child => {
      const child = insertChild(data);
      refreshChildren();
      return child;
    },
    [refreshChildren]
  );

  const updateChildById = useCallback(
    (id: string, data: Partial<Omit<Child, 'id' | 'createdAt'>>): void => {
      updateChild(id, data);
      refreshChildren();
    },
    [refreshChildren]
  );

  const deleteChildById = useCallback(
    (id: string): void => {
      deleteChild(id);
      refreshChildren();
    },
    [refreshChildren]
  );

  return {
    children,
    addChild,
    updateChild: updateChildById,
    deleteChild: deleteChildById,
    refreshChildren,
  };
}
