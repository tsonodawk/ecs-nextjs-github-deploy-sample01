import { Meta, StoryObj } from '@storybook/react'
import Button from './Button'

const meta = {
  title: 'Button',
  component: Button,
  argTypes: {
    variant: {
      control: {
        type: 'select',
        options: ['orange', 'green'],
      },
    },
  },
  // parameters: {
  //   // Optional parameter to center the component in the Canvas. More info: https://storybook.js.org/docs/react/configure/story-layout
  //   layout: "centered",
  // },
  // This component will have an automatically generated Autodocs entry: https://storybook.js.org/docs/react/writing-docs/autodocs
  tags: ['autodocs'],
  // // More on argTypes: https://storybook.js.org/docs/react/api/argtypes
  // argTypes: {
  //   backgroundColor: { control: "color" },
  // },
} satisfies Meta<typeof Button>

export default meta
type Story = StoryObj<typeof meta>

/**
 * オレンジ色のボタン
 */
export const Default: Story = {
  args: {
    variant: 'default',
    text: 'デフォルト',
  },
}

/**
 * 緑色のボタン
 */
export const Green: Story = {
  args: {
    variant: 'green',
    text: 'グリーン',
  },
}

/**
 * 赤色のボタン
 */
export const Red: Story = {
  args: {
    variant: 'red',
    text: '赤色',
  },
}

/**
 * きいろ色のボタン
 */
export const Yellow: Story = {
  args: {
    variant: 'yellow',
    text: 'きいろ',
  },
}
