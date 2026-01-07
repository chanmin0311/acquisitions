export const formatValidationError = errors => {
  if (!errors || !errors.issues) return 'Validation Error';

  if (Array.isArray(errors))
    return errors.issues.map(e => e.message).join(', ');

  return JSON.stringify(errors);
  // return errors.issues.map(e => e.message).join(', ');
};
