import Image from 'next/image'
import Button from './components/atoms/Button'

export default function Home() {
  return (
    <main className="flex flex-col items-center justify-between p-24">
      <h1>Hallo Next.js</h1>
      <p>deploy</p>
      <div>
        <Button variant="red" text="Button" />
      </div>
    </main>
  )
}
