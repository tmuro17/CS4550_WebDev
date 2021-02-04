import { render, screen } from '@testing-library/react';
import App from './App';

test('renders Guesses text', () => {
  render(<App />);
  const linkElement = screen.getByText(/Guesses:/i);
  expect(linkElement).toBeInTheDocument();
});
