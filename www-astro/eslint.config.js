// @ts-check
import { defineConfig } from 'eslint/config';
import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import eslintPluginAstro from 'eslint-plugin-astro';
import eslintPluginImportX from 'eslint-plugin-import-x';
import eslintPluginReact from '@eslint-react/eslint-plugin';
import eslintConfigPrettier from 'eslint-config-prettier';

export default defineConfig(
  { ignores: ['dist/', '.astro/'] },
  js.configs.recommended,
  tseslint.configs.recommended,
  eslintPluginAstro.configs.recommended,
  eslintPluginImportX.configs['flat/recommended'],
  eslintPluginReact.configs.recommended,
  {
    rules: {
      'no-var': 'error',
      'import-x/order': [
        'error',
        {
          groups: [
            ['builtin', 'external', 'internal'],
            ['parent', 'sibling', 'index'],
          ],
        },
      ],
      'import-x/no-named-as-default-member': 'off',
    },
  },
  eslintConfigPrettier
);
